class FullName
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
  include Lotus::Validations

  attribute :attr
end

class AttributeTest
  include Lotus::Validations

  attribute 'attr'
end

class UniquenessAttributeTest
  include Lotus::Validations

  attribute :attr
  attribute :attr
end

class AnotherValidator
  include Lotus::Validations

  attribute :another
end

class MultipleValidationsTest
  include Lotus::Validations

  attribute :email, confirmation: true, format: /@/
end

class TypeValidatorTest
  include Lotus::Validations

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
  include Lotus::Validations

  attribute :untyped
  attribute :name,                 presence: true
  attribute :age,   type: Integer, presence: true
end

class FormatValidatorTest
  include Lotus::Validations

  attribute :name,                 format: /\A[a-zA-Z]+\z/
  attribute :age,   type: Integer, format: /\A[0-9]+\z/
end

class InclusionValidatorTest
  include Lotus::Validations

  attribute :job,                  inclusion: ['Carpenter', 'Blacksmith']
  attribute :state,                inclusion: { 'ma' => 'Massachussets' }
  attribute :sport,                inclusion: Set.new(['Football', 'Baseball'])
  attribute :age,   type: Integer, inclusion: 21..65
  attribute :code,                 inclusion: 'aeiouy'
end

class ExclusionValidatorTest
  include Lotus::Validations

  attribute :job,                  exclusion: ['Carpenter', 'Blacksmith']
  attribute :state,                exclusion: { 'ma' => 'Massachussets' }
  attribute :sport,                exclusion: Set.new(['Football', 'Baseball'])
  attribute :age,   type: Integer, exclusion: 21..65
  attribute :code,                 exclusion: 'aeiouy'
end

class AcceptanceValidatorTest
  include Lotus::Validations

  attribute :tos, acceptance: true
end

class CfSize
  def to_int
    16
  end
end

class SizeValidatorTest
  include Lotus::Validations

  attribute :password, size: 9..56
  attribute :ssn,      size: 11
  attribute :cf,       size: CfSize.new
end

class SizeValidatorErrorTest
  include Lotus::Validations

  attribute :password, size: 'nine'
end

class ConfirmationValidatorTest
  include Lotus::Validations

  attribute :password, confirmation: true
end

class SuperclassValidatorTest
  include Lotus::Validations

  attribute :name, presence: true
end

class SubclassValidatorTest < SuperclassValidatorTest
  attribute :age, type: Integer, inclusion: 18..99
end

class VisibilityValidatorTest
  include Lotus::Validations

  attribute :name

  def get_attributes
    self.attributes
  end
end

module EmailValidations
  include Lotus::Validations

  attribute :email, presence: true, format: /@/
end

module CommonValidations
  include EmailValidations
end

class ComposedValidationsTest
  include EmailValidations
end

module PasswordValidations
  include Lotus::Validations

  attribute :password, presence: true
end

class ComposedValidationsWithExtraAttributesTest
  include Lotus::Validations
  include EmailValidations

  attribute :name, presence: true
end

class NestedComposedValidationsTest
  include CommonValidations
end

class DecoratedValidations
  include PasswordValidations

  attribute :password, confirmation: true
end
