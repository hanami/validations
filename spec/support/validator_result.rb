RSpec.shared_context 'validator result' do
  let(:result) { @validator.new(input).validate }
end
