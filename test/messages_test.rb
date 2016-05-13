require 'test_helper'

describe 'Messages' do
  describe 'with anonymous class' do
    before do
      @validator = Class.new do
        include Hanami::Validations
        messages 'test/fixtures/messages.yml'
        namespace :foo

        validations do
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

  describe 'with concrete class' do
    before do
      @validator = SignupValidator
    end

    it 'returns configured message' do
      result = @validator.new(age: 11).validate

      result.wont_be :success?
      result.messages.fetch(:age).must_equal ['must be an adult']
    end
  end

  describe 'with concrete namespaced class' do
    before do
      @validator = Web::Controllers::Signup::Create::Params
    end

    it 'returns configured message' do
      result = @validator.new(age: 11).validate

      result.wont_be :success?
      result.messages.fetch(:age).must_equal ['must be an adult']
    end
  end
end
