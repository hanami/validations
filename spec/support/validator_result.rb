RSpec.shared_context 'validator result' do
  let(:validator) { validator_class.new }
  let(:result) { validator.call(input) }
end
