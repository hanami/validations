require 'test_helper'

describe 'Predicates: decimal?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { decimal? }
    end
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, BigDecimal, nil)
    ]
  end

  it 'returns failing result for nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, BigDecimal, nil)
    ]
  end

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, BigDecimal, '')
    ]
  end

  it 'returns failing result for Array' do
    result = @validator.new(name: []).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, BigDecimal, [])
    ]
  end

  it 'returns failing result for Hash' do
    result = @validator.new(name: {}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, BigDecimal, {})
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
    result = @validator.new(name: Time.at(0)).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, BigDecimal, Time.at(0))
    ]
  end
end
