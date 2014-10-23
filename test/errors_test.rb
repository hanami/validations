require 'test_helper'

describe Lotus::Validations do
  before do
    @validator = PresenceValidatorTest.new(name: nil)
    @validator.valid?
  end

  describe '#errors' do
    it 'exposes the error set' do
      @validator.errors.must_be_kind_of(Lotus::Validations::Errors)
      @validator.errors.count.must_equal(2)
    end

    it 'clears up the error set before to validate again' do
      3.times { @validator.valid? }
      @validator.errors.count.must_equal(2)
    end
  end
end
