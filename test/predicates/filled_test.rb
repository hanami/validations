require 'test_helper'

describe 'Predicates: filled?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { filled? }
    end
  end

  it 'raises error for missing data' do
    exception = -> { @validator.new({}).validate }.must_raise(NoMethodError)
    exception.message.must_equal "undefined method `empty?' for nil:NilClass"
  end

  it 'raises error for missing nil data' do
    exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
    exception.message.must_equal "undefined method `empty?' for nil:NilClass"
  end

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :filled?, nil, '')
    ]
  end

  it 'returns failing result for empty array' do
    result = @validator.new(name: []).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :filled?, nil, [])
    ]
  end

  it 'returns failing result for empty Hash' do
    result = @validator.new(name: {}).validate

    result.wont_be :success?
    result.errors.for(:name).must_equal [
      Hanami::Validations::Error.new(:name, :filled?, nil, {})
    ]
  end

  it 'returns successful result for filled string' do
    result = @validator.new(name: 'foo').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for filled array' do
    result = @validator.new(name: [:foo]).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns successful result for filled hash' do
    result = @validator.new(name: { foo: 1 }).validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
