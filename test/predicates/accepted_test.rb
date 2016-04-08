require 'test_helper'

describe 'Predicates: accepted?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { accepted? }
    end
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :accepted?, true, nil)
    ]
  end

  it 'returns failing result for nil' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :accepted?, true, nil)
    ]
  end

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :accepted?, true, '')
    ]
  end

  it 'returns failing result for Array' do
    result = @validator.new(name: []).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :accepted?, true, [])
    ]
  end

  it 'returns failing result for Hash' do
    result = @validator.new(name: {}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :accepted?, true, {})
    ]
  end

  it 'returns failing result for string that represents false' do
    result = @validator.new(name: '0').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :accepted?, true, '0')
    ]
  end

  it 'returns successful result for string that represents true' do
    result = @validator.new(name: '1').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for integer that represents false' do
    result = @validator.new(name: 0).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :accepted?, true, 0)
    ]
  end

  it 'returns successful result for integer that represents true' do
    result = @validator.new(name: 1).validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
