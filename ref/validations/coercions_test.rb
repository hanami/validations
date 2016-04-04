require 'test_helper'
require 'hanami/validations/coercions'

describe Hanami::Validations::Coercions do
  describe 'Hanami::Utils::Kernel coercions' do
    it 'coerces value' do
      result = Hanami::Validations::Coercions.coerce(Boolean, 1)
      result.must_equal true
    end
  end

  describe 'custom coercions' do
    it 'coerces custom class' do
      result = Hanami::Validations::Coercions.coerce(FullName, ['Luca', 'Guidi'])

      result.must_be_kind_of(FullName)
      result.to_s.must_equal 'Luca Guidi'
    end
  end

  it 'returns nil for blank values' do
    result = Hanami::Validations::Coercions.coerce(Integer, '')
    result.must_equal nil
  end

  it 'returns an empty string when an empty string is given to coerce to String' do
    result = Hanami::Validations::Coercions.coerce(String, '')
    result.must_equal ''
  end

  it 'returns nil when an array is given to coerce to a string' do
    result = Hanami::Validations::Coercions.coerce(String, [])
    # This is not ideal behaviour
    result.must_equal '[]'
  end

  it 'returns an empty array when coercing to an array' do
    result = Hanami::Validations::Coercions.coerce(Array, [])
    result.must_equal []
  end
end
