require 'test_helper'

describe Hanami::Validations do
  describe 'nested validations' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validates(:number) { present? }

        group(:customer) do
          validates(:name) { present? }

          group(:address) do
            validates(:city) { present? }
          end
        end
      end
    end

    it 'returns successful validation result for valid data' do
      result = @validator.new(number: 23, customer: { name: 'Luca', address: { city: 'Rome' } }).validate
      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing validation result for invalid data' do
      result = @validator.new({}).validate
      result.wont_be :success?
      result.errors.keys.must_equal [:number, :'customer.name', :'customer.address.city']
      result.errors.for(:number).must_equal [Hanami::Validations::Error.new(:number, :present?, nil, nil)]
      result.errors.for(:'customer.name').must_equal [Hanami::Validations::Error.new(:'customer.name', :present?, nil, nil)]
      result.errors.for(:'customer.address.city').must_equal [Hanami::Validations::Error.new(:'customer.address.city', :present?, nil, nil)]
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58
    it 'safely serialize to nested Hash' do
      data      = {name: 'John Smith', address: { line_one: '10 High Street' }}
      validator = @validator.new(data)

      validator.to_h.must_equal(data)
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58#issuecomment-99144243
    it 'safely serialize to Hash' do
      data      = {name: 'John Smith', tags: [1, 2]}
      validator = @validator.new(data)

      validator.to_h.must_equal(data)
    end
  end
end
