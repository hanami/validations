require 'dry-validation'
require 'hanami/utils/class_attribute'

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
      end
    end

    # Validations DSL
    #
    # @since 0.1.0
    module ClassMethods
      def validations(&blk)
        schema = Dry::Validation.__send__(_schema_type, build: false, &blk)
        schema.configure(&_schema_config)

        self.schema = schema.new
      end

      private

      def _schema_type
        :Schema
      end

      def _schema_config
        lambda do |config|
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
