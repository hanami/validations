RSpec.describe Hanami::Validations do
  let(:validator_class) do
    Class.new(Hanami::Validations) do
      validations do
        required(:name) { filled? }
      end
    end
  end

  let(:validator) { validator_class.new }

  it 'returns successful validation result for valid data' do
    result = validator.call(name: 'Luca')

    expect(result).to be_success
    expect(result.errors).to be_empty
  end

  it 'returns failing validation result for invalid data' do
    result = validator.call({})

    expect(result).not_to be_success
    expect(result.messages.fetch(:name)).to eq ['is missing']
  end
end
