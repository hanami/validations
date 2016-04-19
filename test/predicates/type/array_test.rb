require 'test_helper'

describe 'Predicates: type?(Array)' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { type?(Array) }
    end
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, Array, nil)
    ]
  end

  it 'returns failing result for nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, Array, nil)
    ]
  end

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, Array, '')
    ]
  end

  it 'returns failing result for Hash' do
    result = @validator.new(name: {}).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, Array, {})
    ]
  end

  it 'returns successful result for Array' do
    result = @validator.new(name: []).validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
