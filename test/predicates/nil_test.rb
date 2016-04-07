require 'test_helper'

describe 'Predicates: nil?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { nil? }
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

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :nil?, nil, '')
    ]
  end

  it 'returns successful result for data' do
    result = @validator.new(name: 'X').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :nil?, nil, 'X')
    ]
  end
end
