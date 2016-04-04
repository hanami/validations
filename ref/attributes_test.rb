require 'test_helper'

describe Hanami::Validations do
  before do
    @validator = VisibilityValidatorTest.new(name: 'Luca', unwanted: 'nope', password: 'secret', password_confirmation: 'secret')
  end

  describe '#to_h' do
    it 'returns an instance of ::Hash' do
      @validator.to_h.must_be_instance_of(::Hash)
    end

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

    it 'allows developers to mixin Enumerable to enhance API' do
      validator = EnumerableValidator.new(name: 'Luca')
      validator.count.must_equal(1)
    end
  end
end
