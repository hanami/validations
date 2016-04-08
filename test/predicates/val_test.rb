require 'test_helper'

describe 'Predicates: confirmed?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:number) { format?(/\A#{val(:'customer.address.city_code')}\_/) }

      group(:customer) do
        group(:address) do
          validates(:city_code) { present? }
        end
      end
    end
  end

  it 'successfully access given data' do
    result = @validator.new(number: 'RM_123', customer: { address: { city_code: 'RM' } }).validate
    result.must_be :success?
    result.errors.must_be_empty
  end
end
