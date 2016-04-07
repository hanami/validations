require 'test_helper'

describe 'Predicates: confirmed?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:password) { confirmed? }
    end
  end

  it 'returns successful result for missing data' do
    result = @validator.new({}).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for missing confirmation' do
    result = @validator.new(password: 'secret').validate

    result.wont_be :success?
    result.errors.fetch(:password).must_equal [
      Hanami::Validations::Error.new(:password, :confirmed?, 'secret', nil)
    ]
  end

  it 'returns failing result for missing value' do
    result = @validator.new(password_confirmation: 'secret').validate

    result.wont_be :success?
    result.errors.fetch(:password).must_equal [
      Hanami::Validations::Error.new(:password, :confirmed?, nil, 'secret')
    ]
  end

  it 'returns successful result for both nil values' do
    result = @validator.new(password: nil, password_confirmation: nil).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for nil confirmation' do
    result = @validator.new(password: 'secret', password_confirmation: nil).validate

    result.wont_be :success?
    result.errors.fetch(:password).must_equal [
      Hanami::Validations::Error.new(:password, :confirmed?, 'secret', nil)
    ]
  end

  it 'returns failing result for nil value' do
    result = @validator.new(password: nil, password_confirmation: 'secret').validate

    result.wont_be :success?
    result.errors.fetch(:password).must_equal [
      Hanami::Validations::Error.new(:password, :confirmed?, nil, 'secret')
    ]
  end

  it 'returns successful result for both blank values' do
    result = @validator.new(password: '', password_confirmation: '').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for blank confirmation' do
    result = @validator.new(password: 'secret', password_confirmation: '').validate

    result.wont_be :success?
    result.errors.fetch(:password).must_equal [
      Hanami::Validations::Error.new(:password, :confirmed?, 'secret', '')
    ]
  end

  it 'returns failing result for blank value' do
    result = @validator.new(password: '', password_confirmation: 'secret').validate

    result.wont_be :success?
    result.errors.fetch(:password).must_equal [
      Hanami::Validations::Error.new(:password, :confirmed?, '', 'secret')
    ]
  end

  it 'returns successful result for equal values' do
    result = @validator.new(password: 'secret', password_confirmation: 'secret').validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
