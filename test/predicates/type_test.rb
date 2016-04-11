require 'test_helper'

describe 'Predicates: type?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { type?(Integer) && value.positive? }
    end
  end

  it 'fails with missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, Integer, nil)
    ]
  end

  it 'fails with nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, Integer, nil)
    ]
  end

  it 'fails with failed coercion' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :type?, Integer, '')
    ]
  end

  it 'passes control with successful coercion' do
    result = @validator.new(name: '1').validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
