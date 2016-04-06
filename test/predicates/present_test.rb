require 'test_helper'

describe 'Predicates: present?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { present? }
    end
  end

  it 'returns successful result for valid data' do
    result = @validator.new(name: 'Luca').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for missing data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :present?, nil, nil)
    ]
  end

  it 'returns failing result for nil data' do
    result = @validator.new(name: nil).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :present?, nil, nil)
    ]
  end

  it 'returns failing result for blank data' do
    result = @validator.new(name: '').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :present?, nil, '')
    ]
  end
end
