require 'test_helper'

describe Hanami::Validations do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validations do
        key(:name) { filled? }
      end
    end
  end

  it 'returns successful validation result for valid data' do
    result = @validator.new(name: 'Luca').validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing validation result for invalid data' do
    result = @validator.new({}).validate

    result.wont_be :success?
    result.messages.fetch(:name).must_equal ['is missing']
  end
end
