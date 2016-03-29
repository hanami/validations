class FullName
  attr_reader :tokens
  def initialize(*tokens)
    @tokens = tokens
  end

  def to_s
    @tokens.join ' '
  end
end

class Params
  def initialize(attributes)
    @attributes = Hash[*attributes]
  end

  def to_h
    @attributes.to_h
  end
end

class InitializerTest
  include Hanami::Validations

  attribute :attr, type: Integer
end

class AttributeTest
  include Hanami::Validations
  extend  Hanami::Validations::ValidationIntrospection

  attribute 'attr'
end

class UndefinedAttributesValidator
  include Hanami::Validations
  attribute :name

  def [](key)
    read_attributes[key]
  end
end

class MethodAssignmentTest
  include Hanami::Validations
  attribute :name

  def ==(other)
    @equal_param = other
    true
  end

  def equal_param
    @equal_param
  end
end

class UniquenessAttributeTest
  include Hanami::Validations
  extend  Hanami::Validations::ValidationIntrospection

  attribute :attr
  attribute :attr
end

class AnotherValidator
  include Hanami::Validations

  attribute :another
end

class MultipleValidationsTest
  include Hanami::Validations

  attribute :email, confirmation: true, format: /@/
end

class TypeValidatorTest
  include Hanami::Validations

  attribute :untyped
  attribute :array_attr,         type: Array
  attribute :boolean_true_attr,  type: Boolean
  attribute :boolean_false_attr, type: Boolean
  attribute :date_attr,          type: Date
  attribute :datetime_attr,      type: DateTime
  attribute :float_attr,         type: Float
  attribute :hash_attr,          type: Hash
  attribute :integer_attr,       type: Integer
  attribute :pathname_attr,      type: Pathname
  attribute :set_attr,           type: Set
  attribute :string_attr,        type: String
  attribute :symbol_attr,        type: Symbol
  attribute :time_attr,          type: Time
  attribute :name_attr,          type: FullName
end

class PresenceValidatorTest
  include Hanami::Validations

  attribute :untyped
  attribute :name,                 presence: true
  attribute :age,   type: Integer, presence: true
end

class FormatValidatorTest
  include Hanami::Validations

  attribute :name,               format: /\A[a-zA-Z]+\z/
  attribute :age,  type: String, format: /\A[0-9]+\z/
end

class InclusionValidatorTest
  include Hanami::Validations

  attribute :job,                  inclusion: ['Carpenter', 'Blacksmith']
  attribute :state,                inclusion: { 'ma' => 'Massachussets' }
  attribute :sport,                inclusion: Set.new(['Football', 'Baseball'])
  attribute :age,   type: Integer, inclusion: 21..65
  attribute :code,                 inclusion: 'aeiouy'
end

class ExclusionValidatorTest
  include Hanami::Validations

  attribute :job,                  exclusion: ['Carpenter', 'Blacksmith']
  attribute :state,                exclusion: { 'ma' => 'Massachussets' }
  attribute :sport,                exclusion: Set.new(['Football', 'Baseball'])
  attribute :age,   type: Integer, exclusion: 21..65
  attribute :code,                 exclusion: 'aeiouy'
end

class AcceptanceValidatorTest
  include Hanami::Validations

  attribute :tos, acceptance: true
end

class CfSize
  def to_int
    16
  end
end

class SizeValidatorTest
  include Hanami::Validations

  attribute :password, size: 9..56
  attribute :ssn,      size: 11
  attribute :cf,       size: CfSize.new
end

class SizeValidatorErrorTest
  include Hanami::Validations

  attribute :password, size: 'nine'
end

class ConfirmationValidatorTest
  include Hanami::Validations

  attribute :password, confirmation: true
end

class SuperclassValidatorTest
  include Hanami::Validations

  attribute :name, presence: true
end

class SubclassValidatorTest < SuperclassValidatorTest
  attribute :age, type: Integer, inclusion: 18..99
end

class VisibilityValidatorTest
  include Hanami::Validations

  attribute :name
  attribute :password, confirmation: true
end

module EmailValidations
  include Hanami::Validations

  attribute :email, presence: true, format: /@/
end

module EmailValidationsWithoutPresence
  include Hanami::Validations

  attribute :email, format: /@/
end

module CommonValidations
  include EmailValidations
end

class ComposedValidationsTest
  include EmailValidations
end

class ComposedValidationsWithoutPresenceTest
  include EmailValidationsWithoutPresence

  attribute :name, size: 8..50
end

module PasswordValidations
  include Hanami::Validations

  attribute :password, presence: true
end

class ComposedValidationsWithExtraAttributesTest
  include Hanami::Validations
  include EmailValidations

  attribute :name, presence: true
end

class NestedComposedValidationsTest
  include CommonValidations
end

class UndecoratedValidations
  include PasswordValidations
end

class DecoratedValidations
  include PasswordValidations

  attribute :password, confirmation: true
end

class Signup
  include Hanami::Validations

  attribute :email,    presence: true
  attribute :password, presence: true, confirmation: true
end

class EnumerableValidator
  include Enumerable
  include Hanami::Validations

  attribute :name
end

class CustomAttributesValidator
  include Hanami::Validations

  attribute :name

  def initialize(attributes)
    @attributes = Hanami::Utils::Attributes.new({ already: 'initialized' })
    super
  end

  def to_h
    @attributes.to_h
  end
end

class PureValidator
  include Hanami::Validations
  attr_accessor :name, :age

  validates :name, presence: true
end

# Custom validator class
class CustomValidator
  include Hanami::Validations::Validation

  def validate()
    return is_valid if value == 0
    return add_error_overriding_default_values if value == 1
    return add_error_for_another_attribute if value == 2
    return add_error_for_another_attribute_with_missing_parameters if value == 3
    return override_validation_name if value == 4
    return ask_if_previous_validation_failed if blank_value? || value == 5
    return ask_if_previous_validation_failed_for_another_attribute if value == 6
    return invoke_another_validation if value == 7
    return add_error_with_object_id if value == 8
    return ask_for_another_attribute_value if value == 9
    return ask_for_a_nested_attribute_value if value == 10
    return invoke_a_validation_on_a_nested_attribute if value == 11
    return ask_if_any_previous_validation_failed if blank_value? || value == 12

    add_error
  end

  def is_valid
  end

  def add_error_overriding_default_values
      add_error attribute_name: 'name',
        validation_name: :another_validation,
        expected_value: 'expected: 1',
        actual_value: 'actual: 1',
        namespace: 'some_namespace'
  end

  def add_error_for_another_attribute
      add_error_for 'name',
        validation_name: :another_validation,
        expected_value: 'expected: 2',
        actual_value: 'actual: 2',
        namespace: 'some_namespace'
  end

  def add_error_for_another_attribute_with_missing_parameters
      add_error_for 'name'
  end

  def override_validation_name
    validation_name :other_validation
    add_error
  end

  def ask_if_previous_validation_failed
    add_error unless validation_failed_for? :presence
  end

  def ask_if_previous_validation_failed_for_another_attribute
    add_error unless validation_failed_for? :presence, on: 'name'
  end

  def add_error_with_object_id
    add_error actual_value: object_id
  end

  def invoke_another_validation
    validate_attribute 'name', on: :format, with: /abc/
  end

  def invoke_an_inexistent_validation
    validate_attribute 'name', on: :not_found
  end

  def ask_for_another_attribute_value
    add_error validation_name: :asked_value if value_of('name') == 'martin'
  end

  def ask_for_a_nested_attribute_value
    add_error validation_name: :asked_nested_value if value_of('address.street') == 'evergreen'
  end

  def invoke_a_validation_on_a_nested_attribute
    validate_attribute 'address.street', on: :format, with: /abc/
  end

  def ask_if_any_previous_validation_failed
    add_error unless any_validation_failed?
  end
end

class ValidateWithClassBehaviourTest
  include Hanami::Validations

  attribute :name,  presence: true
  attribute :age,   type: Integer, presence: true, validate_custom_with: CustomValidator
  attribute :address do
    attribute :street, presence: true
    attribute :number, presence: true
  end
end

class ValidateWithInstanceBehaviourTest
  include Hanami::Validations

  attribute :name,  presence: true
  attribute :age,   type: Integer, presence: true, validate_custom_with: CustomValidator.new
  attribute :address do
    attribute :street, presence: true
    attribute :number, presence: true
  end
end

# Custom validator block
class ValidateWithBlockBehaviourTest
  include Hanami::Validations

  attribute :name,  presence: true
  attribute :age,   type: Integer, presence: true,
                    validate_custom_with: proc{
                      if value == 0
                      end

                      if value == 1
                        add_error attribute_name: 'name',
                          validation_name: :another_validation,
                          expected_value: 'expected: 1',
                          actual_value: 'actual: 1',
                          namespace: 'some_namespace'
                      end

                      if value == 2
                        add_error_for 'name',
                          validation_name: :another_validation,
                          expected_value: 'expected: 2',
                          actual_value: 'actual: 2',
                          namespace: 'some_namespace'
                      end

                      if value == 3
                        add_error_for 'name'
                      end

                      if value == 4
                        validation_name :other_validation
                        add_error
                      end

                      if blank_value? || value == 5
                        add_error unless validation_failed_for? :presence
                      end

                      if value == 6
                        add_error unless validation_failed_for? :presence, on: 'name'
                      end

                      if value == 7
                        validate_attribute 'name', on: :format, with: /abc/
                      end

                      if value == 8
                        add_error actual_value: object_id
                      end

                      if value == 9
                        add_error validation_name: :asked_value if value_of('name') == 'martin'
                      end

                      if value == 10
                        if value_of('address.street') == 'evergreen'
                          add_error validation_name: :asked_nested_value
                        end
                      end

                      if value == 11
                        validate_attribute 'address.street', on: :format, with: /abc/
                      end

                      if value == 12
                        add_error unless any_validation_failed?
                      end

                      if !blank_value? && value >= 13
                        add_error
                      end
                    }
  attribute :address do
    attribute :street, presence: true
    attribute :number, presence: true
  end
end

# Multiple custom validators
class BeginsWithUpcaseValidator
  include Hanami::Validations::Validation

  def validate()
    add_error if value[0] != value[0].upcase
  end
end

class SingleWordValidator
  include Hanami::Validations::Validation

  def validate()
    add_error if value.split.size > 1
  end
end

class MultilpeCustomValidationsTest
  include Hanami::Validations

  attribute :name, validate_case_with: BeginsWithUpcaseValidator,
                   validate_single_word_with: SingleWordValidator
end

class ValidationsOrderTest
  include Hanami::Validations
  extend  Hanami::Validations::ValidationIntrospection

  attribute :name, presence: true, size: 1..3
  attribute :last_name, validate_case_with: BeginsWithUpcaseValidator, size: 1..3, presence: true

  validates :name, inclusion: ['abc']
end