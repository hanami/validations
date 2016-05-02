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
    if value == 'duplicates the validation instance'
      add_error actual_value: object_id
    end

    if value == 'is valid'
    end

    if value =='adds a default error'
      add_error
    end

    if value == 'adds an error overriding its values'
      add_error(attribute_name: 'name',
        validation_name: :expected_name,
        expected_value: 'expected name',
        actual_value: 'actual name',
        namespace: 'name_namespace'
      )
    end

    if value == 'adds an error for another attribute'
      add_error_for 'age',
        validation_name: :age_validation,
        expected_value: 'expected age',
        actual_value: 'actual age',
        namespace: 'age_namespace'
    end

    if value == 'raises an error when adding an error for another attribute with missing parameters'
      add_error_for 'age'
    end

    if value == 'overrides the validation name'
      validation_name :other_validation
      add_error
    end

    if value == 'asks for the value of another attribute'
      if value_of('age') == 4
        add_error actual_value: 'asks for the value of another attribute'
      end
    end

    if value == 'asks for the value of a nested attribute'
      if value_of('address.street') == 'evergreen'
        add_error actual_value: 'asks for the value of a nested attribute'
      end
    end

    if value == 'asks if a previous validation failed for the default attribute'
      if validation_failed_for? :format
        raise RuntimeError.new('should not get here')
      end

      validate_attribute 'name', on: :format, with: /abc/

      if validation_failed_for? :format
        add_error actual_value: 'asks if a previous validation failed for the default attribute'
      end
    end

    if value == 'asks if a previous validation failed for another attribute'
      if validation_failed_for? :inclusion, on: 'age'
        raise RuntimeError.new('should not get here')
      end

      validate_attribute 'age', on: :inclusion, with: 0..1

      if validation_failed_for? :inclusion, on: 'age'
        add_error actual_value: 'asks if a previous validation failed for another attribute'
      end
    end

    if value == 'invokes another validation'
      if (validate_on :format, with: /abc/) != false
        raise RuntimeError.new('should not get here')
      end
    end

    if value == 'invokes another validation on an attribute'
      if (validate_attribute 'name', on: :format, with: /abc/) != false
        raise RuntimeError.new('should not get here')
      end
    end

    if value == 'invokes a validation on a nested attribute'
      if (validate_attribute 'address.street', on: :format, with: /abc/) != false
        raise RuntimeError.new('should not get here')
      end
    end

    if value == 'asks if any previous validation failed for the default attribute'
      if any_validation_failed?
        raise RuntimeError.new('should not get here')
      end

      validate_attribute 'name', on: :format, with: /abc/

      if any_validation_failed?
        add_error actual_value: 'asks if any previous validation failed for the default attribute'
      end
    end

    if value == 'asks if any previous validation failed for another attribute'
      if any_validation_failed?
        raise RuntimeError.new('should not get here')
      end

      validate_attribute 'age', on: :inclusion, with: 0..1

      if any_validation_failed? on: 'age'
        add_error actual_value: 'asks if any previous validation failed for another attribute'
      end
    end
  end
end

class ValidateWithClassBehaviourTest
  include Hanami::Validations

  attribute :name,  presence: true, validate_custom_with: CustomValidator
  attribute :age,   type: Integer, presence: true
  attribute :address do
    attribute :street, presence: true
    attribute :number, presence: true
  end
end

class ValidateWithInstanceBehaviourTest
  include Hanami::Validations

  attribute :name,  presence: true, validate_custom_with: CustomValidator
  attribute :age,   type: Integer, presence: true
  attribute :address do
    attribute :street, presence: true
    attribute :number, presence: true
  end
end

# Custom validator block
class ValidateWithBlockBehaviourTest
  include Hanami::Validations

  attribute :name,  presence: true,
                    validate_custom_with: proc{
                      if value == 'is valid'
                      end

                      if value =='adds a default error'
                        add_error
                      end

                      if value == 'adds an error overriding its values'
                        add_error(attribute_name: 'name',
                          validation_name: :expected_name,
                          expected_value: 'expected name',
                          actual_value: 'actual name',
                          namespace: 'name_namespace'
                        )
                      end

                      if value == 'adds an error for another attribute'
                        add_error_for 'age',
                          validation_name: :age_validation,
                          expected_value: 'expected age',
                          actual_value: 'actual age',
                          namespace: 'age_namespace'
                      end

                      if value == 'raises an error when adding an error for another attribute with missing parameters'
                        add_error_for 'age'
                      end

                      if value == 'overrides the validation name'
                        validation_name :other_validation
                        add_error
                      end

                      if value == 'asks for the value of another attribute'
                        if value_of('age') == 4
                          add_error actual_value: 'asks for the value of another attribute'
                        end
                      end

                      if value == 'asks for the value of a nested attribute'
                        if value_of('address.street') == 'evergreen'
                          add_error actual_value: 'asks for the value of a nested attribute'
                        end
                      end

                      if value == 'asks if a previous validation failed for the default attribute'
                        if validation_failed_for? :format
                          raise RuntimeError.new('should not get here')
                        end

                        validate_attribute 'name', on: :format, with: /abc/

                        if validation_failed_for? :format
                          add_error actual_value: 'asks if a previous validation failed for the default attribute'
                        end
                      end

                      if value == 'asks if a previous validation failed for another attribute'
                        if validation_failed_for? :inclusion, on: 'age'
                          raise RuntimeError.new('should not get here')
                        end

                        validate_attribute 'age', on: :inclusion, with: 0..1

                        if validation_failed_for? :inclusion, on: 'age'
                          add_error actual_value: 'asks if a previous validation failed for another attribute'
                        end
                      end

                      if value == 'invokes another validation'
                        if (validate_on :format, with: /abc/) != false
                          raise RuntimeError.new('should not get here')
                        end
                      end

                      if value == 'invokes another validation on an attribute'
                        if (validate_attribute 'name', on: :format, with: /abc/) != false
                          raise RuntimeError.new('should not get here')
                        end
                      end

                      if value == 'invokes a validation on a nested attribute'
                        if (validate_attribute 'address.street', on: :format, with: /abc/) != false
                          raise RuntimeError.new('should not get here')
                        end
                      end

                      if value == 'asks if any previous validation failed for the default attribute'
                        if any_validation_failed?
                          raise RuntimeError.new('should not get here')
                        end

                        validate_attribute 'name', on: :format, with: /abc/

                        if any_validation_failed?
                          add_error actual_value: 'asks if any previous validation failed for the default attribute'
                        end
                      end

                      if value == 'asks if any previous validation failed for another attribute'
                        if any_validation_failed?
                          raise RuntimeError.new('should not get here')
                        end

                        validate_attribute 'age', on: :inclusion, with: 0..1

                        if any_validation_failed? on: 'age'
                          add_error actual_value: 'asks if any previous validation failed for another attribute'
                        end
                      end
                    }
  attribute :age, type: Integer, presence: true
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