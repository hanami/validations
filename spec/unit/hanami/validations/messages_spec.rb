RSpec.describe 'Messages' do
  let(:validator) { validator_class.new }

  describe 'with anonymous class' do
    let(:validator_class) do
      Class.new(Hanami::Validations) do
        messages_path "spec/support/fixtures/messages.yml"
        namespace :foo

        validations do
          required(:age).filled(:int?, gt?: 18)
        end
      end
    end

    it 'returns configured message' do
      result = validator.call(age: 11)

      expect(result).not_to be_success
      expect(result.messages.fetch(:age)).to eq ['must be an adult']
    end
  end

  describe 'with concrete class' do
    let(:validator_class) do
      SignupValidator
    end

    it 'returns configured message' do
      result = validator.call(age: 11)

      expect(result).not_to be_success
      expect(result.messages.fetch(:age)).to eq ['must be an adult']
    end
  end

  describe 'with concrete namespaced class' do
    let(:validator_class) do
      Web::Controllers::Signup::Create::Params
    end

    it 'returns configured message' do
      result = validator.call(age: 11)

      expect(result).not_to be_success
      expect(result.messages.fetch(:age)).to eq ['must be an adult']
    end
  end

  describe 'with i18n support' do
    let(:validator_class) do
      DomainValidator
    end

    it 'returns configured message' do
      result = validator.call(name: 'a' * 256)

      expect(result).not_to be_success
      expect(result.messages.fetch(:name)).to eq ['is too long']
    end
  end

  describe 'with i18n support and shared predicates' do
    let(:validator_class) do
      ChangedTermsOfServicesValidator
    end

    it 'returns configured message' do
      result = validator.call(terms: 'false')

      expect(result).not_to be_success
      expect(result.messages.fetch(:terms)).to eq ['must be accepted']
    end
  end
end
