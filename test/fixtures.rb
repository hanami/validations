class InitializerTest
  include Lotus::Validations

  attribute :attr
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
