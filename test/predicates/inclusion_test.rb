require 'test_helper'

describe 'Predicates: inclusion?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { inclusion?(1..3) }
    end
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :inclusion?, 1..3, nil)
    ]
  end

  it 'returns failing result for nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :inclusion?, 1..3, nil)
    ]
  end

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :inclusion?, 1..3, '')
    ]
  end

  it 'returns failing result for out of range data' do
    result = @validator.new(name: -1).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :inclusion?, 1..3, -1)
    ]
  end

  it 'returns successful result for in range data' do
    result = @validator.new(name: 3).validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
