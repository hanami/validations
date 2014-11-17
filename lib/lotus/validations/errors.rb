require 'lotus/validations/error'

module Lotus
  module Validations
    # A set of errors for a validator
    #
    # This is the result of calling `#valid?` on a validator.
    #
    # @see Lotus::Validations::Error
    #
    # @since 0.1.0
    class Errors
      # Initialize the errors
      #
      # @since 0.1.0
      # @api private
      def initialize
        @errors = Hash.new {|h,k| h[k] = [] }
      end

      # Check if the set is empty
      #
      # @return [TrueClass,FalseClass] the result of the check
      #
      # @since 0.1.0
      def empty?
        @errors.empty?
      end

      # Returns how many validations have failed
      #
      # @return [Fixnum] the count
      #
      # @since 0.1.0
      def count
        errors.count
      end

      alias_method :size, :count

      # Clears the internal state of the errors
      #
      # @since 0.1.0
      # @api private
      def clear
        @errors.clear
      end

      # Iterate thru the errors and yields the given block
      #
      # @param blk [Proc] the given block
      # @yield [error] a Lotus::Validations::Error
      #
      # @see Lotus::Validations::Error
      #
      # @since 0.1.0
      def each(&blk)
        errors.each(&blk)
      end

      # Iterate thru the errors, yields the given block and collect the
      # returning value.
      #
      # @param blk [Proc] the given block
      # @yield [error] a Lotus::Validations::Error
      #
      # @see Lotus::Validations::Error
      #
      # @since 0.1.0
      def map(&blk)
        errors.map(&blk)
      end

      # Add an error to the set
      #
      # @param attribute [Symbol] the name of the attribute
      # @param validation [Symbol] the name of the validation
      # @param expected [Object] the expected value
      # @param actual [Object] the actual value
      #
      # @since 0.1.0
      # @api private
      def add(attribute, *errors)
        @errors[attribute].push(*errors) if errors.any?
      end

      # Return the errors for the given attribute
      #
      # @param attribute [Symbol] the name of the attribute
      #
      # @since 0.1.0
      def for(attribute)
        @errors[attribute]
      end

      # Check if the current set of errors equals to the one who belongs to
      # `other`.
      #
      # @param other [Object] the other term of comparison
      #
      # @return [TrueClass,FalseClass] the result of comparison
      #
      # @since 0.1.0
      def ==(other)
        other.is_a?(self.class) &&
          other.errors == errors
      end

      alias_method :eql?, :==

      protected
      # A flatten set of errors for all the attributes
      #
      # @since 0.1.0
      # @api private
      def errors
        @errors.values.flatten
      end
    end
  end
end
