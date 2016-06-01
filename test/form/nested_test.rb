require 'test_helper'

describe Hanami::Validations::Form do
  describe 'nested validations' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          required(:number) { filled? }

          required(:customer).schema do
            required(:name) { filled? }

            required(:address).schema do
              required(:city) { filled? }
            end
          end
        end
      end
    end

    it 'returns successful validation result for valid data' do
      result = @validator.new('number' => '23', 'customer' => { 'name' => 'Luca', 'address' => { 'city' => 'Rome' } }).validate

      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing validation result for invalid data' do
      result = @validator.new({}).validate

      result.wont_be :success?
      result.messages.fetch(:number).must_equal ['is missing']
      result.messages.fetch(:customer).must_equal ['is missing']
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58
    it 'safely serialize to nested Hash' do
      data      = { 'customer' => { 'name' => 'John Smith', 'address' => { 'city' => 'London' } } }
      validator = @validator.new(data)

      validator.to_h.must_equal(customer: { name: 'John Smith', address: { city: 'London' } })
    end
  end
end
