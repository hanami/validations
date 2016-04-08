require 'test_helper'

describe 'Predicates: unknown' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { xyz? }
    end
  end

  it 'raises error' do
    exception = -> { @validator.new({}).validate }.must_raise(Hanami::Validations::UnknownPredicateError)
    exception.message.must_equal "Unknown predicate: `xyz?'"
  end
end
