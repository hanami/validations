# Quick fix for non MRI VMs that don't implement Range#size
#
# @since 0.1.0
class Range
  def size
    to_a.size
  end unless instance_methods.include?(:size)
end

Hanami::Validations::ValidationDefinitions.define do
  # Attribute naming convention for "confirmation" validation
  #
  # @see Hanami::Validations::Attribute#confirmation
  #
  # @since 0.2.0
  # @api private
  CONFIRMATION_TEMPLATE = '%{name}_confirmation'.freeze

  # Validates presence of the value.
  # This fails with `nil` and "blank" values.
  #
  # An object is blank if it isn't `nil`, but doesn't hold a value.
  # Empty strings and enumerables are an example.
  #
  # @see Hanami::Validations::ClassMethods#attribute
  # @see Hanami::Validations::Attribute#nil_value?
  #
  # @since 0.2.0
  # @api private
  validation :presence do
    add_error unless !blank_value?
  end

  # Validates acceptance of the value.
  #
  # This passes if the value is "truthy", it fails if not.
  #
  # Truthy examples: `Object.new`, `1`, `"1"`, `true`.
  # Falsy examples: `nil`, `0`, `"0"`, `false`, `""`.
  #
  # @see Hanami::Validations::ClassMethods#attribute
  # @see http://www.rubydoc.info/gems/hanami-utils/Hanami/Utils/Kernel#Boolean-class_method
  #
  # @since 0.2.0
  # @api private
  validation :acceptance do
    add_error unless !blank_value? && Hanami::Utils::Kernel.Boolean(value)
  end

  # Validates format of the value.
  #
  # Coerces the value to a string and then check if it satisfies the defined
  # matcher.
  #
  # @see Hanami::Validations::ClassMethods#attribute
  #
  # @since 0.2.0
  # @api private
  validation :format do
    add_error unless blank_value? || value.to_s.match(expected_value)
  end

  # Validates inclusion of the value in the defined collection.
  #
  # The collection is an objects which implements `#include?`.
  #
  # @see Hanami::Validations::ClassMethods#attribute
  #
  # @since 0.2.0
  # @api private
  validation :inclusion do
    add_error unless value.nil? || expected_value.include?(value)
  end

  # Validates exclusion of the value in the defined collection.
  #
  # The collection is an objects which implements `#include?`.
  #
  # @see Hanami::Validations::ClassMethods#attribute
  #
  # @since 0.2.0
  # @api private
  validation :exclusion do
    add_error unless value.nil? || !expected_value.include?(value)
  end

  # Validates confirmation of the value with another corresponding value.
  #
  # Given a `:password` attribute, it passes if the corresponding attribute
  # `:password_confirmation` has the same value.
  #
  # @see Hanami::Validations::ClassMethods#attribute
  # @see Hanami::Validations::Attribute::CONFIRMATION_TEMPLATE
  #
  # @since 0.2.0
  # @api private
  validation :confirmation do
    add_error unless value == value_of(CONFIRMATION_TEMPLATE % { name: attribute_name })
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
  # If the attribute's value is blank, the size will not be considered
  #
  # The value is an object which implements `#size`.
  #
  # @raise [ArgumentError] if the defined quantity isn't a Numeric or a
  #   collection
  #
  # @see Hanami::Validations::ClassMethods#attribute
  #
  # @since 0.2.0
  # @api private
  validation :size do
    case expected_value
    when Numeric, ->(v) { v.respond_to?(:to_int) }
      add_error unless blank_value? || value.size == expected_value.to_int
    when Range
      add_error unless blank_value? || expected_value.include?(value.size)
    else
      raise ArgumentError.new("Size validator must be a number or a range, it was: #{ expected_value }")
    end
  end

  validation :type do
  end

  # Validates nested Hanami Validations objects
  #
  # @since 0.2.4
  # @api private
  validation :nested do
    nested_namespace = namespace.nil? ? attribute_name : [namespace, attribute_name].join('.')

    errors = value.validate(namespace: nested_namespace)
    errors.each do |error|
      add_validation_error error
    end
  end
end