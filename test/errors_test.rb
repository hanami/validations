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

    it "doesn't have errors after requesting an attribute that doesn't have errors" do
      @validator.name = 'Luca'
      @validator.age = 32
      @validator.valid?.must_equal(true)

      # Triggers the behaviour of making Errors think it now
      # has errors
      @validator.errors.for(:name).must_equal([])

      @validator.errors.any?.must_equal(false)
      @validator.errors.to_h.must_equal({})
    end
  end
end
