RSpec.describe 'Messages' do
  describe 'with anonymous class' do
    before do
      @validator = Class.new do
        include Hanami::Validations
        messages_path "spec/support/fixtures/messages.yml"
        namespace :foo

        validations do
          required(:age).filled(:int?, gt?: 18)
        end
      end
    end

    it 'returns configured message' do
      result = @validator.new(age: 11).validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:age)).to eq ['must be an adult']
    end
  end

  describe 'with concrete class' do
    before do
      @validator = SignupValidator
    end

    it 'returns configured message' do
      result = @validator.new(age: 11).validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:age)).to eq ['must be an adult']
    end
  end

  describe 'with concrete namespaced class' do
    before do
      @validator = Web::Controllers::Signup::Create::Params
    end

    it 'returns configured message' do
      result = @validator.new(age: 11).validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:age)).to eq ['must be an adult']
    end
  end

  describe 'with i18n support' do
    before do
      @validator = DomainValidator
    end

    it 'returns configured message' do
      result = @validator.new(name: 'a' * 256).validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:name)).to eq ['is too long']
    end
  end

  describe 'with i18n support and shared predicates' do
    before do
      @validator = ChangedTermsOfServicesValidator
    end

    it 'returns configured message' do
      result = @validator.new(terms: 'false').validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:terms)).to eq ['must be accepted']
    end
  end
end
