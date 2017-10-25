require 'securerandom'

RSpec.describe Hanami::Validations do
  describe 'rules' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          configure do
            def self.messages
              super.merge(
                en: {
                  errors: {
                    quick_code_presence: 'you must set quick code for connection type "a"',
                    uuid_presence:       'you must set uuid for connection type "b"'
                  }
                }
              )
            end
          end

          required(:connection_type).filled(:str?, included_in?: %w[a b c])
          optional(:quick_code).maybe(:str?)
          optional(:uuid).maybe(:str?)

          rule(quick_code_presence: %i[connection_type quick_code]) do |connection_type, quick_code|
            connection_type.eql?('a') > quick_code.filled?
          end

          rule(uuid_presence: %i[connection_type uuid]) do |connection_type, uuid|
            connection_type.eql?('b') > uuid.filled?
          end
        end
      end
    end

    describe 'quick code' do
      it 'returns successful validation result for valid data' do
        result = @validator.new(connection_type: 'a', quick_code: '123').validate

        expect(result).to be_success
        expect(result.errors).to be_empty
      end

      it 'returns failing validation result when quick code is missing' do
        result = @validator.new(connection_type: 'a').validate

        expect(result).not_to be_success
        expect(result.messages.fetch(:quick_code_presence)).to eq ['you must set quick code for connection type "a"']
      end
    end

    describe 'uuid' do
      it 'returns successful validation result for valid data' do
        result = @validator.new(connection_type: 'b', uuid: SecureRandom.uuid).validate

        expect(result).to be_success
        expect(result.errors).to be_empty
      end

      it 'returns failing validation result when uuid is missing' do
        result = @validator.new(connection_type: 'b').validate

        expect(result).not_to be_success
        expect(result.messages.fetch(:uuid_presence)).to eq ['you must set uuid for connection type "b"']
      end
    end
  end
end
