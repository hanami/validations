require 'test_helper'

describe 'Predicates: value' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { !value.nil? }
    end
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :base, nil, false)
    ]
  end

  it 'returns failing result for nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :base, nil, false)
    ]
  end

  it 'returns successful result if data is present' do
    result = @validator.new(name: 'ok').validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
