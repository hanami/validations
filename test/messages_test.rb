require 'test_helper'

describe 'Messages' do
  describe 'with anonymous class' do
    before do
      @validator = Class.new do
        include Hanami::Validations
        messages_path 'test/fixtures/messages.yml'
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

  describe 'with i18n support' do
    before do
      @validator = DomainValidator
    end

    it 'returns configured message' do
      result = @validator.new(name: 'a' * 256).validate

      result.wont_be :success?
      result.messages.fetch(:name).must_equal ['is too long']
    end
  end

  # https://github.com/dry-rb/dry-validation/issues/183
  # describe 'with i18n support and shared predicates' do
  #   before do
  #     @validator = ChangedTermsOfServicesValidator
  #   end

  #   it 'returns configured message' do
  #     result = @validator.new(terms: 'false').validate

  #     result.wont_be :success?
  #     result.messages.fetch(:terms).must_equal ['must be accepted']
  #   end
  # end
end
