require 'test_helper'

describe 'Predicates: datetime?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { datetime? }
    end
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, nil)
    ]
  end

  it 'returns failing result for nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, nil)
    ]
  end

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, '')
    ]
  end

  it 'returns failing result for Array' do
    result = @validator.new(name: []).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, [])
    ]
  end

  it 'returns failing result for Hash' do
    result = @validator.new(name: {}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, {})
    ]
  end

  it 'returns failing result for string that does not represent a date' do
    result = @validator.new(name: '1').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, '1')
    ]
  end

  it 'returns successful result for string that represents a date' do
    result = @validator.new(name: '2016-04-06').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for string that represents a datetime' do
    result = @validator.new(name: '2016-04-06T17:14:31+02:00').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for string that represents a time' do
    result = @validator.new(name: '2016-04-06 17:15:05 +0200').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for integer' do
    result = @validator.new(name: 1).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, 1)
    ]
  end

  it 'returns failing result for float' do
    result = @validator.new(name: 3.14).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, 3.14)
    ]
  end

  it 'returns failing result for big decimal' do
    result = @validator.new(name: BigDecimal.new(1)).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, DateTime, BigDecimal.new(1))
    ]
  end

  it 'returns successful result for date' do
    result = @validator.new(name: Date.today).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for date time' do
    result = @validator.new(name: DateTime.now).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for time' do
    result = @validator.new(name: Time.now).validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
