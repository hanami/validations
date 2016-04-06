require 'test_helper'

describe 'Predicates: format?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { format?(/\Afoo\z/) }
    end
  end

  it 'raises error for missing data' do
    exception = -> { @validator.new({}).validate }.must_raise(NoMethodError)
    exception.message.must_match "undefined method `match' for nil:NilClass"
  end

  it 'raises error for nil data' do
    exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
    exception.message.must_match "undefined method `match' for nil:NilClass"
  end

  it 'returns failing result for blank string' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :format?, /\Afoo\z/, '')
    ]
  end

  it 'raises error for array' do
    exception = -> { @validator.new(name: []).validate }.must_raise(NoMethodError)
    exception.message.must_match "undefined method `match' for []:Array"
  end

  it 'raises error for hash' do
    exception = -> { @validator.new(name: {}).validate }.must_raise(NoMethodError)
    exception.message.must_match "undefined method `match' for {}:Hash"
  end

  it 'returns successful result for matching string' do
    result = @validator.new(name: 'foo').validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
