require 'test_helper'

describe 'Messages' do
  before do
    @validator = Class.new do
      include Hanami::Validations
      messages 'test/fixtures/messages.yml'

      validations do
        configure do
          config.namespace = :user
        end

        required(:age).filled(:int?, gt?: 18)
      end
    end
  end

  it 'returns configured message' do
    result = @validator.new(age: 11).validate

    result.wont_be :success?
    result.messages.fetch(:age).must_equal ['must be an adult']
  end
end
