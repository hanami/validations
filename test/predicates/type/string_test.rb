require 'test_helper'

describe 'Predicates: type?(String)' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { type?(String) }
    end
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, String, nil)
    ]
  end

  it 'returns failing result for nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, String, nil)
    ]
  end

  it 'returns successful result for blank data' do
    result = @validator.new(name: '').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for Array' do
    result = @validator.new(name: []).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, String, [])
    ]
  end

  it 'returns failing result for Hash' do
    result = @validator.new(name: {}).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, String, {})
    ]
  end

  it 'returns successful result for string that represents a number' do
    result = @validator.new(name: '1').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for integer' do
    result = @validator.new(name: 1).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for float' do
    result = @validator.new(name: 1.12).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for big decimal' do
    result = @validator.new(name: BigDecimal.new(1)).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for time' do
    result = @validator.new(name: Time.now).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for date time' do
    result = @validator.new(name: DateTime.new).validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
