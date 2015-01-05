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
end
