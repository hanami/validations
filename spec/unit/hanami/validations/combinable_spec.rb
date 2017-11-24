RSpec.describe Hanami::Validations do
  describe 'combinable validations' do
    let(:validator_class) do
      address = Class.new(Hanami::Validations) do
        validations do
          required(:city) { filled? }
        end
      end

      customer = Class.new(Hanami::Validations) do
        validations do
          required(:name) { filled? }
          # FIXME: ask dry team to support any object that responds to #schema.
          required(:address).schema(address.schema)
        end
      end

      Class.new(Hanami::Validations) do
        validations do
          required(:number) { filled? }
          required(:customer).schema(customer.schema)
        end
      end
    end

    let(:validator) { validator_class.new }

    it 'returns successful validation result for valid data' do
      result = validator.call(number: 23, customer: { name: 'Luca', address: { city: 'Rome' } })
      expect(result).to be_success
      expect(result.errors).to be_empty
    end

    it 'returns failing validation result for invalid data' do
      result = validator.call({})

      expect(result).not_to be_success
      expect(result.messages.fetch(:number)).to eq   ['is missing']
      expect(result.messages.fetch(:customer)).to eq ['is missing']
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58
    it 'safely serialize to nested Hash' do
      data = { name: 'John Smith', address: { line_one: '10 High Street' } }
      validator.call(data)

      expect(validator.to_h).to eq(data)
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58#issuecomment-99144243
    it 'safely serialize to Hash' do
      data = { name: 'John Smith', tags: [1, 2] }
      validator.call(data)

      expect(validator.to_h).to eq(data)
    end
  end
end
