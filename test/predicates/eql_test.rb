require 'test_helper'

describe 'Predicates: eql?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { eql?(23) }
    end
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :eql?, 23, nil)
    ]
  end

  it 'returns failing result for nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :eql?, 23, nil)
    ]
  end

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :eql?, 23, '')
    ]
  end

  it 'returns successful result for valid data' do
    result = @validator.new(name: 23).validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
