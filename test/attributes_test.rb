require 'test_helper'

describe Lotus::Validations do
  before do
    @validator = VisibilityValidatorTest.new(name: 'Luca', unwanted: 'nope', password: 'secret', password_confirmation: 'secret')
  end

  describe '#to_h' do
    it 'returns a Hash of the internal attributes' do
      @validator.to_h.must_equal({name: 'Luca', password: 'secret', password_confirmation: 'secret'})
    end

    it 'prevents information escape' do
      @validator.to_h[:name].reverse!
      @validator.to_h.must_equal({name: 'Luca', password: 'secret', password_confirmation: 'secret'})
    end
  end

  describe '#each' do
    it 'iterates thru the given block' do
      result = {}

      @validator.each do |attr, value|
        result[attr] = value
      end

      result.must_equal(@validator.to_h)
    end
  end
end
