require 'test_helper'

describe Lotus::Validations do
  describe 'acceptance' do
    # it "is valid if it doesn't have attributes" do
    #   validator = AcceptanceValidatorTest.new({})

    #   validator.valid?.must_equal true
    #   validator.errors.must_be_empty
    # end

    it "is valid if it the value can be coercible to TrueClass" do
      [1, '1', true, Object.new, :thruthy].each do |value|
        validator = AcceptanceValidatorTest.new({tos: value})

        validator.valid?.must_equal true
        validator.errors.must_be_empty
      end
    end

    it "isn't valid if it isn't equal to true" do
      [0, '0', false, nil].each do |value|
        validator = AcceptanceValidatorTest.new({tos: value})

        validator.valid?.must_equal false
        validator.errors.fetch(:tos).must_include :acceptance
      end
    end
  end
end
