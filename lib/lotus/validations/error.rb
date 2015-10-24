require 'lotus/utils/string'

module Lotus
  module Validations
    # A single validation error for an attribute
    #
    # @since 0.1.0
    class Error
      # @since 0.2.4
      # @api private
      NAMESPACE_SEPARATOR = '.'.freeze

      # @since x.x.x
      # @api private
      DEFAULT_ERROR_MESSAGES = {
        acceptance:   ->(error) { "must be accepted" },
        confirmation: ->(error) { "doesn't match" },
        exclusion:    ->(error) { "shouldn't belong to #{ Array(error.expected).join(', ') }" },
        format:       ->(error) { "doesn't match expected format" },
        inclusion:    ->(error) { "isn't included" },
        presence:     ->(error) { "must be present" },
        size:         ->(error) { "doesn't match expected size" },
      }

      # The name of the attribute
      #
      # @return [Symbol] the name of the attribute
      #
      # @since 0.2.4
      #
      # @see Lotus::Validations::Error#attribute
      #
      # @example
      #   error = Error.new(
      #     attribute_name: :name,
      #     validation: :presence,
      #     actual: true,
      #     namespace: 'author')
      #
      #   error.attribute      # => "author.name"
      #   error.attribute_name # => "name"
      attr_reader :attribute_name

      # The name of the validation
      #
      # @return [Symbol] the name of the validation
      #
      # @since 0.1.0
      attr_reader :validation

      # The expected value
      #
      # @return [Object] the expected value
      #
      # @since 0.1.0
      attr_reader :expected

      # The actual value
      #
      # @return [Object] the actual value
      #
      # @since 0.1.0
      attr_reader :actual

      # Returns the namespaced attribute name
      #
      # In cases where the error was pulled up from nested validators,
      # `attribute` will be a namespaced string containing
      # parent attribute names separated by a period.
      #
      # @since 0.1.0
      #
      # @see Lotus::Validations::Error#attribute_name
      #
      # @example
      #   error = Error.new(
      #     attribute_name: :name,
      #     validation: :presence,
      #     actual: true,
      #     namespace: 'author')
      #
      #   error.attribute      # => "author.name"
      #   error.attribute_name # => "name"
      attr_accessor :attribute

      # Initialize a validation error
      #
      # @param options [Hash]
      # @option attribute_name [Symbol] the name of the attribute
      # @option validation [Symbol] the name of the validation
      # @option expected [Object] the expected value
      # @option actual [Object] the actual value
      # @option namespace [String] the namespace
      # @option validator_name [String] validator name
      #
      # @since x.x.x
      # @api private
      def initialize(options = {})
        @attribute_name = options[:attribute_name].to_s
        @validation     = options[:validation]
        @expected       = options[:expected]
        @actual         = options[:actual]
        @validator_name = options[:validator_name]
        @namespace      = options[:namespace]
        @attribute      = [@namespace, attribute_name].flatten.compact.join(NAMESPACE_SEPARATOR)
      end

      # Check if self equals to `other`
      #
      # @since 0.1.0
      def ==(other)
        other.is_a?(self.class) &&
          other.attribute  == attribute  &&
          other.validation == validation &&
          other.expected   == expected   &&
          other.actual     == actual
      end

      # FIXME for Luca - What to do when I18n isn't defined?
      #
      # @since x.x.x
      # @api private
      def to_s
        I18n.translate(i18n_key, default: error_message)
      end

      private

      # @since x.x.x
      # @api private
      def i18n_key
        [@validator_name, @attribute, @validation].join(NAMESPACE_SEPARATOR)
      end

      # @since x.x.x
      # @api private
      def error_message
        "#{Utils::String.new(@attribute_name).capitalize} #{DEFAULT_ERROR_MESSAGES.fetch(@validation).call(self)}"
      end
    end
  end
end
