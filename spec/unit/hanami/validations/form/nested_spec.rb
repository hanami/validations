RSpec.describe Hanami::Validations::Form do
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

      expect(result).to be_success
      expect(result.errors).to be_empty
    end

    it 'returns failing validation result for invalid data' do
      result = @validator.new({}).validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:number)).to eq ['is missing']
      expect(result.messages.fetch(:customer)).to eq ['is missing']
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58
    it 'safely serialize to nested Hash' do
      data      = { 'customer' => { 'name' => 'John Smith', 'address' => { 'city' => 'London' } } }
      validator = @validator.new(data)

      expect(validator.to_h).to eq(customer: { name: 'John Smith', address: { city: 'London' } })
    end
  end
end
