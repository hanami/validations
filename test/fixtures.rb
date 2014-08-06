class InitializerTest
  include Lotus::Validations

  attribute :attr
end

class AnotherValidator
  include Lotus::Validations

  attribute :another
end

class TypeValidatorTest
  include Lotus::Validations

  attribute :untyped
  attribute :array_attr,    type: Array
  attribute :boolean_attr,  type: Boolean
  attribute :date_attr,     type: Date
  attribute :datetime_attr, type: DateTime
  attribute :float_attr,    type: Float
  attribute :hash_attr,     type: Hash
  attribute :integer_attr,  type: Integer
  attribute :pathname_attr, type: Pathname
  attribute :set_attr,      type: Set
  attribute :string_attr,   type: String
  attribute :symbol_attr,   type: Symbol
  attribute :time_attr,     type: Time
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
