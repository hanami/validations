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
        @errors = Hash.new
      end

      # Check if the set is empty
      #
      # @return [TrueClass,FalseClass] the result of the check
      #
      # @since 0.1.0
      #
      # @see Lotus::Validations::Errors#any?
      def empty?
        @errors.empty?
      end

      # Check if the set has any entry
      #
      # @return [TrueClass,FalseClass] the result of the check
      #
      # @since 0.2.0
      #
      # @see Lotus::Validations::Errors#empty?
      def any?
        @errors.any?
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
      # @param errors [Array] a collection of errors
      #
      # @since 0.1.0
      # @api private
      #
      # @see Lotus::Validations::Error
      def add(attribute, *errors)
        if errors.any?
          @errors[attribute] ||= []
          @errors[attribute].push(*errors)
        end
      end

      # Return the errors for the given attribute
      #
      # @param attribute [Symbol] the name of the attribute
      #
      # @since 0.1.0
      def for(attribute)
        @errors.fetch(attribute) { [] }
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

      # Return a serializable Hash representation of the errors.
      #
      # @return [Lotus::Utils::Hash] the Hash
      #
      # @since 0.2.1
      def to_h
        Utils::Hash.new(@errors).deep_dup
      end

      # Return a flat collection of errors.
      #
      # @return [Array]
      #
      # @since 0.2.1
      def to_a
        errors.dup
      end

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
