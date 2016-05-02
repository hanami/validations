require 'test_helper'

describe 'Predicates: exclude?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { exclude?(1..3) }
    end
  end

  it 'returns successful result for missing data' do
    result = @validator.new({}).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for nil data' do
    result = @validator.new(name: nil).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for blank data' do
    result = @validator.new(name: '').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for out of range data' do
    result = @validator.new(name: -1).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for in range data' do
    result = @validator.new(name: 3).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :exclude?, 1..3, 3)
    ]
  end
end
