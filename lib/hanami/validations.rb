require 'dry-validation'
require 'hanami/utils/class_attribute'
require 'hanami/validations/namespace'
require 'hanami/validations/predicates'
require 'hanami/validations/inline_predicate'
require 'set'

Dry::Validation::Messages::Namespaced.configure do |config|
  # rubocop:disable Lint/NestedPercentLiteral
  #
  # This is probably a false positive.
  # See: https://github.com/bbatsov/rubocop/issues/5314
  config.lookup_paths = config.lookup_paths + %w[
    %<root>s.%<rule>s.%<predicate>s
  ].freeze
  # rubocop:enable Lint/NestedPercentLiteral
end

# @since 0.1.0
module Hanami
  # Hanami::Validations is a set of lightweight validations for Ruby objects.
  #
  # @since 0.1.0
  #
  # @example
  #   require 'hanami/validations'
  #
  #   class Signup
  #     include Hanami::Validations
  #
  #     validations do
  #       # ...
  #     end
  #   end
  module Validations
    # @since 0.6.0
    # @api private
    DEFAULT_MESSAGES_ENGINE = :yaml

    # Override Ruby's hook for modules.
    #
    # @param base [Class] the target action
    #
    # @since 0.1.0
    # @api private
    #
    # @see http://www.ruby-doc.org/core/Module.html#method-i-included
    def self.included(base) # rubocop:disable Metrics/MethodLength
      base.class_eval do
        extend ClassMethods

        include Utils::ClassAttribute
        class_attribute :schema
        class_attribute :_messages
        class_attribute :_messages_path
        class_attribute :_namespace
        class_attribute :_predicates_module

        class_attribute :_predicates
        self._predicates = Set.new
      end
    end

    # Validations DSL
    #
    # @since 0.1.0
    module ClassMethods
      # Define validation rules from the given block.
      #
      # @param blk [Proc] validation rules
      #
      # @since 0.6.0
      #
      # @see https://guides.hanamirb.org/validations/overview
      #
      # @example Basic Example
      #   require 'hanami/validations'
      #
      #   class Signup
      #     include Hanami::Validations
      #
      #     validations do
      #       required(:name).filled
      #     end
      #   end
      #
      #   result = Signup.new(name: "Luca").validate
      #
      #   result.success? # => true
      #   result.messages # => []
      #   result.output   # => {:name=>""}
      #
      #   result = Signup.new(name: "").validate
      #
      #   result.success? # => false
      #   result.messages # => {:name=>["must be filled"]}
      #   result.output   # => {:name=>""}
      def validations(&blk) # rubocop:disable Metrics/AbcSize
        schema_predicates = _predicates_module || __predicates

        base   = _build(predicates: schema_predicates, &_base_rules)
        schema = _build(predicates: schema_predicates, rules: base.rules, &blk)
        schema.configure(&_schema_config)
        schema.configure(&_schema_predicates)
        schema.extend(__messages) unless _predicates.empty?

        self.schema = schema.new
      end

      # Define an inline predicate
      #
      # @param name [Symbol] inline predicate name
      # @param message [String] optional error message
      # @param blk [Proc] predicate implementation
      #
      # @return nil
      #
      # @since 0.6.0
      #
      # @example Without Custom Message
      #   require 'hanami/validations'
      #
      #   class Signup
      #     include Hanami::Validations
      #
      #     predicate :foo? do |actual|
      #       actual == 'foo'
      #     end
      #
      #     validations do
      #       required(:name).filled(:foo?)
      #     end
      #   end
      #
      #   result = Signup.new(name: nil).call
      #   result.messages # => { :name => ['is invalid'] }
      #
      # @example With Custom Message
      #   require 'hanami/validations'
      #
      #   class Signup
      #     include Hanami::Validations
      #
      #     predicate :foo?, message: 'must be foo' do |actual|
      #       actual == 'foo'
      #     end
      #
      #     validations do
      #       required(:name).filled(:foo?)
      #     end
      #   end
      #
      #   result = Signup.new(name: nil).call
      #   result.messages # => { :name => ['must be foo'] }
      def predicate(name, message: 'is invalid', &blk)
        _predicates << InlinePredicate.new(name, message, &blk)
      end

      # Assign a set of shared predicates wrapped in a module
      #
      # @param mod [Module] a module with shared predicates
      #
      # @since 0.6.0
      #
      # @see Hanami::Validations::Predicates
      #
      # @example
      #   require 'hanami/validations'
      #
      #   module MySharedPredicates
      #     include Hanami::Validations::Predicates
      #
      #     predicate :foo? fo |actual|
      #       actual == 'foo'
      #     end
      #   end
      #
      #   class MyValidator
      #     include Hanami::Validations
      #     predicates MySharedPredicates
      #
      #     validations do
      #       required(:name).filled(:foo?)
      #     end
      #   end
      def predicates(mod)
        self._predicates_module = mod
      end

      # Define the type of engine for error messages.
      #
      # Accepted values are `:yaml` (default), `:i18n`.
      #
      # @param type [Symbol] the preferred engine
      #
      # @since 0.6.0
      #
      # @example
      #   require 'hanami/validations'
      #
      #   class Signup
      #     include Hanami::Validations
      #
      #     messages :i18n
      #   end
      def messages(type)
        self._messages = type
      end

      # Define the path where to find translation file
      #
      # @param path [String] path to translation file
      #
      # @since 0.6.0
      #
      # @example
      #   require 'hanami/validations'
      #
      #   class Signup
      #     include Hanami::Validations
      #
      #     messages_path 'config/messages.yml'
      #   end
      def messages_path(path)
        self._messages_path = path
      end

      # Namespace for error messages.
      #
      # @param name [String] namespace
      #
      # @since 0.6.0
      #
      # @example
      #   require 'hanami/validations'
      #
      #   module MyApp
      #     module Validators
      #       class Signup
      #         include Hanami::Validations
      #
      #         namespace 'signup'
      #       end
      #     end
      #   end
      #
      #   # Instead of looking for error messages under the `my_app.validator.signup`
      #   # namespace, it will look just for `signup`.
      #   #
      #   # This helps to simplify YAML files where are stored error messages
      def namespace(name = nil)
        if name.nil?
          Namespace.new(_namespace, self)
        else
          self._namespace = name.to_s
        end
      end

      private

      # @since 0.6.0
      # @api private
      def _build(options = {}, &blk)
        options = { build: false }.merge(options)
        Dry::Validation.__send__(_schema_type, options, &blk)
      end

      # @since 0.6.0
      # @api private
      def _schema_type
        :Schema
      end

      # @since 0.6.0
      # @api private
      def _base_rules
        lambda do
        end
      end

      # @since 0.6.0
      # @api private
      def _schema_config
        lambda do |config|
          config.messages      = _messages      unless _messages.nil?
          config.messages_file = _messages_path unless _messages_path.nil?
          config.namespace     = namespace

          require "dry/validation/messages/i18n" if config.messages == :i18n
        end
      end

      # @since 0.6.0
      # @api private
      def _schema_predicates
        return if _predicates_module.nil? && _predicates.empty?

        lambda do |config|
          config.messages      = _predicates_module&.messages || DEFAULT_MESSAGES_ENGINE
          config.messages_file = _predicates_module.messages_path unless _predicates_module.nil?

          require "dry/validation/messages/i18n" if config.messages == :i18n
        end
      end

      # @since 0.6.0
      # @api private
      def __predicates
        mod = Module.new { include Hanami::Validations::Predicates }

        _predicates.each do |p|
          mod.module_eval do
            predicate(p.name, &p.to_proc)
          end
        end

        mod
      end

      # @since 0.6.0
      # @api private
      def __messages # rubocop:disable Metrics/MethodLength
        result = _predicates.each_with_object({}) do |p, ret|
          ret[p.name] = p.message
        end

        # @api private
        Module.new do
          @@__messages = result # rubocop:disable Style/ClassVars

          # @api private
          def self.extended(base)
            base.instance_eval do
              def __messages
                Hash[en: { errors: @@__messages }]
              end
            end
          end

          # @api private
          def messages
            engine = super

            if engine.respond_to?(:merge)
              engine
            else
              engine.messages
            end.merge(__messages)
          end
        end
      end
    end

    # Initialize a new instance of a validator
    #
    # @param input [#to_h] a set of input data
    #
    # @since 0.6.0
    def initialize(input = {})
      @input = input.to_h
    end

    # Validates the object.
    #
    # @return [Dry::Validations::Result]
    #
    # @since 0.2.4
    def validate
      self.class.schema.call(@input)
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
