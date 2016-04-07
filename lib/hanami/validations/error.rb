module Hanami
  module Validations
    # A single validation error for an attribute
    #
    # @since 0.1.0
    class Error
      # @since x.x.x
      attr_reader :key

      # @since x.x.x
      attr_reader :predicate

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

      # Initialize a validation error
      #
      # @param key [Symbol]
      # @param predicate [Symbol]
      # @param expected [Object] the expected value
      # @param actual [Object] the actual value
      #
      # @since 0.1.0
      # @api private
      def initialize(key, predicate, expected, actual)
        @key       = key
        @predicate = predicate
        @expected  = expected
        @actual    = actual
      end

      # Check if self equals to `other`
      #
      # @since 0.1.0
      def ==(other)
        key == other.key &&
          predicate == other.predicate &&
          expected  == other.expected &&
          actual    == other.actual
      end
    end
  end
end
