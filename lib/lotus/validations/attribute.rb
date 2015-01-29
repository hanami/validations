require 'lotus/validations/coercions'

# Quick fix for non MRI VMs that don't implement Range#size
#
# @since 0.1.0
class Range
  def size
    to_a.size
  end unless instance_methods.include?(:size)
end

module Lotus
  module Validations
    # A validable attribute
    #
    # @since 0.1.0
    # @api private
    class Attribute
      # Attribute naming convention for "confirmation" validation
      #
      # @see Lotus::Validations::Attribute#confirmation
      #
      # @since 0.2.0
      # @api private
      CONFIRMATION_TEMPLATE = '%{name}_confirmation'.freeze

      # Instantiate an attribute
      #
      # @param attributes [Hash] a set of attributes and values coming from the
      #   input
      # @param name [Symbol] the name of the attribute
      # @param value [Object,nil] the value coming from the input
      # @param validations [Hash] a set of validation rules
      #
      # @since 0.2.0
      # @api private
      def initialize(attributes, name, value, validations, errors)
        @attributes  = attributes
        @name        = name
        @value       = value
        @validations = validations
        @errors      = errors
      end

      # @api private
      # @since 0.2.0
      def validate
        presence
        acceptance

        return if skip?

        format
        inclusion
        exclusion
        size
        confirmation
        nested

        @errors
      end

      # @api private
      # @since 0.2.0
      attr_reader :value

      private
      # Validates presence of the value.
      # This fails with `nil` and "blank" values.
      #
      # An object is blank if it isn't `nil`, but doesn't hold a value.
      # Empty strings and enumerables are an example.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      # @see Lotus::Validations::Attribute#nil_value?
      #
      # @since 0.2.0
      # @api private
      def presence
        _validate(__method__) { !blank_value? }
      end

      # Validates acceptance of the value.
      #
      # This passes if the value is "truthy", it fails if not.
      #
      # Truthy examples: `Object.new`, `1`, `"1"`, `true`.
      # Falsey examples: `nil`, `0`, `"0"`, `false`.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      # @see http://www.rubydoc.info/gems/lotus-utils/Lotus/Utils/Kernel#Boolean-class_method
      #
      # @since 0.2.0
      # @api private
      def acceptance
        _validate(__method__) { Lotus::Utils::Kernel.Boolean(@value) }
      end

      # Validates format of the value.
      #
      # Coerces the value to a string and then check if it satisfies the defined
      # matcher.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since 0.2.0
      # @api private
      def format
        _validate(__method__) {|matcher| @value.to_s.match(matcher) }
      end

      # Validates inclusion of the value in the defined collection.
      #
      # The collection is an objects which implements `#include?`.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since 0.2.0
      # @api private
      def inclusion
        _validate(__method__) {|collection| collection.include?(value) }
      end

      # Validates exclusion of the value in the defined collection.
      #
      # The collection is an objects which implements `#include?`.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since 0.2.0
      # @api private
      def exclusion
        _validate(__method__) {|collection| !collection.include?(value) }
      end

      # Validates confirmation of the value with another corresponding value.
      #
      # Given a `:password` attribute, it passes if the corresponding attribute
      # `:password_confirmation` has the same value.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      # @see Lotus::Validations::Attribute::CONFIRMATION_TEMPLATE
      #
      # @since 0.2.0
      # @api private
      def confirmation
        _validate(__method__) do
          _attribute == _attribute(CONFIRMATION_TEMPLATE % { name: @name })
        end
      end

      # Validates if value's size matches the defined quantity.
      #
      # The quantity can be a Ruby Numeric:
      #
      #   * `Integer`
      #   * `Fixnum`
      #   * `Float`
      #   * `BigNum`
      #   * `BigDecimal`
      #   * `Complex`
      #   * `Rational`
      #   * Octal literals
      #   * Hex literals
      #   * `#to_int`
      #
      # The quantity can be also any object which implements `#include?`.
      #
      # If the quantity is a Numeric, the size of the value MUST be exactly the
      # same.
      #
      # If the quantity is a Range, the size of the value MUST be included.
      #
      # The value is an object which implements `#size`.
      #
      # @raise [ArgumentError] if the defined quantity isn't a Numeric or a
      #   collection
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since 0.2.0
      # @api private
      def size
        _validate(__method__) do |validator|
          case validator
          when Numeric, ->(v) { v.respond_to?(:to_int) }
            value.size == validator.to_int
          when Range
            validator.include?(value.size)
          else
            raise ArgumentError.new("Size validator must be a number or a range, it was: #{ validator }")
          end
        end
      end

      # Validates nested Lotus Validations objects
      #
      # @since 0.2.4
      # @api private
      def nested
        _validate(__method__) do |validator|
          errors = value.validate
          errors.each do |error|
            new_error = Error.new(error.attribute, error.validation, error.expected, error.actual, @name)
            @errors.add new_error.attribute, new_error
          end
          true
        end
      end

      # @since 0.1.0
      # @api private
      def skip?
        @value.nil?
      end

      # Checks if the value is "blank".
      #
      # @see Lotus::Validations::BlankValueChecker
      #
      # @since 0.2.0
      # @api private
      def blank_value?
        BlankValueChecker.new(@value).blank_value?
      end

      # Reads an attribute from the validator.
      #
      # @since 0.2.0
      # @api private
      def _attribute(name = @name)
        @attributes[name.to_sym]
      end

      # Run a single validation and collects the results.
      #
      # @since 0.2.0
      # @api private
      def _validate(validation)
        if (validator = @validations[validation]) && !(yield validator)
          @errors.add(@name, Error.new(@name, validation, @validations.fetch(validation), @value))
        end
      end
    end
  end
end
