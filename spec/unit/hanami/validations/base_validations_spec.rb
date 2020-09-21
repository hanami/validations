# frozen_string_literal: true
RSpec.describe Hanami::Validations do
  describe 'base validations' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        def self._base_rules
          lambda do
            optional(:_csrf_token).filled(:str?)
          end
        end

        validations do
          required(:number).filled(:int?, eql?: 23)
        end
      end
    end

    it 'returns successful validation result with bare minimum valid data' do
      result = @validator.new(number: 23).validate

      expect(result).to be_success
      expect(result.errors).to be_empty

      expect(result.output).to eq(number: 23)
    end

    it 'returns successful validation result with full valid data' do
      result = @validator.new(number: 23, _csrf_token: 'abc').validate

      expect(result).to be_success
      expect(result.messages).to be_empty

      expect(result.output).to eq(number: 23, _csrf_token: 'abc')
    end

    it 'returns failing validation result with bare minimum invalid data' do
      result = @validator.new(number: 11).validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:number)).to eq          ['must be equal to 23']
      expect(result.messages.fetch(:_csrf_token, [])).to eq []

      expect(result.output).to eq(number: 11)
    end

    it 'returns failing validation result with full invalid data' do
      result = @validator.new(number: 8, _csrf_token: '').validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:number)).to eq      ['must be equal to 23']
      expect(result.messages.fetch(:_csrf_token)).to eq ['must be filled']

      expect(result.output).to eq(number: 8, _csrf_token: '')
    end

    it 'returns failing validation result with base invalid data' do
      result = @validator.new(number: 23, _csrf_token: '').validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:number, [])).to eq  []
      expect(result.messages.fetch(:_csrf_token)).to eq ['must be filled']

      expect(result.output).to eq(number: 23, _csrf_token: '')
    end

    it 'returns failing validation result for invalid data' do
      result = @validator.new({}).validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:number)).to eq          ['is missing', 'must be equal to 23']
      expect(result.messages.fetch(:_csrf_token, [])).to eq []

      expect(result.output).to eq({})
    end
  end
end
