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
      # @since x.x.x
      # @api private
      CONFIRMATION_TEMPLATE = '%{name}_confirmation'.freeze

      # Instantiate an attribute
      #
      # @param validator [Lotus::Validations] an object which included
      #   Lotus::Validations module
      # @param name [Symbol] the name of the attribute
      # @param options [Hash] the set of validations for the attribute
      #
      # @since x.x.x
      # @api private
      # def initialize(validator, name, options)
      #   @validator, @name, @options = validator, name, options
      #   @value = _attribute(@name)
      # end
      def initialize(attributes, name, value, validations)
        @attributes  = attributes
        @name        = name
        @value       = value
        @validations = validations
        @errors      = []
      end

      # @api private
      # @since x.x.x
      def validate
        _with_cleared_errors do
          presence
          acceptance

          _run_validations
        end
      end

      # @api private
      # @since x.x.x
      def value
        if (coercer = @validations[:type])
          Lotus::Validations::Coercions.coerce(coercer, @value)
        else
          @value
        end
      end

      def value=(value)
        @value = value
      end

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
      # @since x.x.x
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
      # @since x.x.x
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
      # @since x.x.x
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
      # @since x.x.x
      # @api private
      def inclusion
        _validate(__method__) {|collection| collection.include?(@value) }
      end

      # Validates exclusion of the value in the defined collection.
      #
      # The collection is an objects which implements `#include?`.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since x.x.x
      # @api private
      def exclusion
        _validate(__method__) {|collection| !collection.include?(@value) }
      end

      # Validates confirmation of the value with another corresponding value.
      #
      # Given a `:password` attribute, it passes if the corresponding attribute
      # `:password_confirmation` has the same value.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      # @see Lotus::Validations::Attribute::CONFIRMATION_TEMPLATE
      #
      # @since x.x.x
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
      # @since x.x.x
      # @api private
      def size
        _validate(__method__) do |validator|
          case validator
          when Numeric, ->(v) { v.respond_to?(:to_int) }
            @value.size == validator.to_int
          when Range
            validator.include?(@value.size)
          else
            raise ArgumentError.new("Size validator must be a number or a range, it was: #{ validator }")
          end
        end
      end

      # Coerces the value to the defined type.
      # Built in types are:
      #
      #   * `Array`
      #   * `BigDecimal`
      #   * `Boolean`
      #   * `Date`
      #   * `DateTime`
      #   * `Float`
      #   * `Hash`
      #   * `Integer`
      #   * `Pathname`
      #   * `Set`
      #   * `String`
      #   * `Symbol`
      #   * `Time`
      #
      # If a user defined class is specified, it can be freely used for coercion
      # purposes. The only limitation is that the constructor should have
      # **arity of 1**.
      #
      # @raise [ArgumentError] if the custom coercer's `#initialize` has a wrong arity.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      # @see Lotus::Validations::Coercions
      #
      # @since x.x.x
      # @api private
      def coerce
        _validate(:type) do |coercer|
          @value = Lotus::Validations::Coercions.coerce(coercer, @value)
          true
        end
      end

      # Checks if the value is `nil`.
      #
      # @since x.x.x
      # @api private
      def nil_value?
        @value.nil?
      end

      alias_method :skip?, :nil_value?

      # Checks if the value is "blank".
      #
      # @see Lotus::Validations::Attribute#presence
      #
      # @since x.x.x
      # @api private
      def blank_value?
        nil_value? || (@value.respond_to?(:empty?) && @value.empty?)
      end

      # Run the defined validations
      #
      # @since x.x.x
      # @api private
      def _run_validations
        return if skip?

        format
        coerce
        inclusion
        exclusion
        size
        confirmation
      end

      # @api private
      # @since x.x.x
      def _with_cleared_errors
        @errors.clear
        yield
        @errors.dup.tap {|_| @errors.clear }
      end

      # Reads an attribute from the validator.
      #
      # @since x.x.x
      # @api private
      def _attribute(name = @name)
        @attributes[name.to_sym]
      end

      # Run a single validation and collects the results.
      #
      # @since x.x.x
      # @api private
      def _validate(validation)
        if (validator = @validations[validation]) && !(yield validator)
          @errors.push(Error.new(@name, validation, @validations.fetch(validation), @value))
        end
      end
    end
  end
end
