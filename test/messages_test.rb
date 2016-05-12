require 'test_helper'

describe 'Messages' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validations do
        configure do
          config.namespace     = :user
          config.messages_file = 'test/fixtures/messages.yml'
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
