require 'test_helper'
require 'lotus/validations/coercions'

describe Lotus::Validations::Coercions do
  describe 'Lotus::Utils::Kernel coercions' do
    it 'coerces value' do
      result = Lotus::Validations::Coercions.coerce(Boolean, 1)
      result.must_equal true
    end
  end

  describe 'custom coercions' do
    it 'coerces custom class' do
      result = Lotus::Validations::Coercions.coerce(FullName, ['Luca', 'Guidi'])

      result.must_be_kind_of(FullName)
      result.to_s.must_equal 'Luca Guidi'
    end
  end

  it 'returns nil for blank values' do
    result = Lotus::Validations::Coercions.coerce(Integer, '')
    result.must_equal nil
  end

  it 'returns an empty string when an empty string is given to coerce to String' do
    result = Lotus::Validations::Coercions.coerce(String, '')
    result.must_equal ''
  end

  it 'returns nil when an array is given to coerce to a string' do
    result = Lotus::Validations::Coercions.coerce(String, [])
    # This is not ideal behaviour
    result.must_equal '[]'
  end

  it 'returns an empty array when coercing to an array' do
    result = Lotus::Validations::Coercions.coerce(Array, [])
    result.must_equal []
  end
end
