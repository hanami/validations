require 'test_helper'

describe Hanami::Validations::Form do
  describe 'base validations' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

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
      result = @validator.new('number' => '23').validate

      result.must_be :success?
      result.messages.must_be_empty

      result.output.must_equal(number: 23)
    end

    it 'returns successful validation result with full valid data' do
      result = @validator.new('number' => '23', '_csrf_token' => 'abc').validate

      result.must_be :success?
      result.messages.must_be_empty

      result.output.must_equal(number: 23, _csrf_token: 'abc')
    end

    it 'returns failing validation result with bare minimum invalid data' do
      result = @validator.new('number' => '11').validate

      result.wont_be :success?
      result.messages.fetch(:number).must_equal          ['must be equal to 23']
      result.messages.fetch(:_csrf_token, []).must_equal []

      result.output.must_equal(number: 11)
    end

    it 'returns failing validation result with full invalid data' do
      result = @validator.new('number' => '8', '_csrf_token' => '').validate

      result.wont_be :success?
      result.messages.fetch(:number).must_equal      ['must be equal to 23']
      result.messages.fetch(:_csrf_token).must_equal ['must be filled']

      result.output.must_equal(number: 8, _csrf_token: '')
    end

    it 'returns failing validation result with base invalid data' do
      result = @validator.new('number' => '23', '_csrf_token' => '').validate

      result.wont_be :success?
      result.messages.fetch(:number, []).must_equal  []
      result.messages.fetch(:_csrf_token).must_equal ['must be filled']

      result.output.must_equal(number: 23, _csrf_token: '')
    end

    it 'returns failing validation result for invalid data' do
      result = @validator.new({}).validate

      result.wont_be :success?
      result.messages.fetch(:number).must_equal          ['is missing', 'must be equal to 23']
      result.messages.fetch(:_csrf_token, []).must_equal []

      result.output.must_equal({})
    end

    it 'whitelists known keys' do
      result = @validator.new('number' => '23', '_csrf_token' => 'abc', 'foo' => 'bar').validate

      result.must_be :success?
      result.messages.must_be_empty

      result.output.must_equal(number: 23, _csrf_token: 'abc')
    end
  end
end
