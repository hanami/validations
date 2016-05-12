require 'dry-validation'
require 'hanami/utils/class_attribute'
require 'hanami/validations/predicates'
require 'hanami/validations/inline_predicate'
require 'set'

module Hanami
  # Hanami::Validations is a set of lightweight validations for Ruby objects.
  #
  # @since 0.1.0
  module Validations
    # Override Ruby's hook for modules.
    #
    # @param base [Class] the target action
    #
    # @since 0.1.0
    # @api private
    #
    # @see http://www.ruby-doc.org/core/Module.html#method-i-included
    def self.included(base)
      base.class_eval do
        extend ClassMethods

        include Utils::ClassAttribute
        class_attribute :schema
        class_attribute :_predicates_module

        class_attribute :_predicates
        self._predicates = Set.new
      end
    end

    # Validations DSL
    #
    # @since 0.1.0
    module ClassMethods
      def validations(&blk)
        base   = _build(&_base_rules)
        schema = _build(rules: base.rules, &blk)
        schema.configure(&_schema_predicates)
        schema.configure(&_schema_config)
        schema.extend(_messages) unless _predicates.empty?

        self.schema = schema.new
      end

      def predicate(name, message: 'is invalid', &blk)
        _predicates << InlinePredicate.new(name, message, &blk)
      end

      def predicates(mod)
        self._predicates_module = mod
      end

      private

      def _build(options = {}, &blk)
        options = { build: false }.merge(options)
        Dry::Validation.__send__(_schema_type, options, &blk)
      end

      def _schema_type
        :Schema
      end

      def _base_rules
        lambda do
        end
      end

      def _schema_config
        lambda do |_config|
        end
      end

      def _schema_predicates
        return if _predicates_module.nil? && _predicates.empty?

        lambda do |config|
          config.predicates    = _predicates_module || __predicates
          config.messages_file = _predicates_module && _predicates_module.messages
        end
      end

      def __predicates
        mod = Module.new { include Hanami::Validations::Predicates }

        _predicates.each do |p|
          mod.module_eval do
            predicate(p.name, &p.to_proc)
          end
        end

        mod
      end

      def _messages
        result = _predicates.each_with_object({}) do |p, ret|
          ret[p.name] = p.message
        end

        Module.new do
          @@_messages = result

          def self.extended(base)
            base.instance_eval do
              def _messages
                Hash[en: { errors: @@_messages }]
              end
            end
          end

          def messages
            super.merge(_messages)
          end
        end
      end
    end

    def initialize(input)
      @input = input.to_h
    end

    # Validates the object.
    #
    # @return [Errors]
    #
    # @since 0.2.4
    def validate
      self.class.schema.call(@input)
    end

    # Iterates thru the defined attributes and their values
    #
    # @param blk [Proc] a block
    # @yield param attribute [Symbol] the name of the attribute
    # @yield param value [Object,nil] the value of the attribute
    #
    # @since 0.2.0
    def each(&blk)
      to_h.each(&blk)
    end

    # Returns a Hash with the defined attributes as symbolized keys, and their
    # relative values.
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def to_h
      validate.output
    end
  end
end
