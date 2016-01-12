require 'test_helper'

describe Lotus::Validations do
  describe 'acceptance' do
    it "is isn't valid if it doesn't have attributes" do
      validator = AcceptanceValidatorTest.new({})

      validator.valid?.must_equal false
      error = validator.errors.for(:tos)
      error.must_include Lotus::Validations::Error.new(
        attribute_name: :tos,
        validation: :acceptance,
        expected: true,
        actual: nil,
        validator_name: 'acceptance_validator_test')
    end

    it "is valid if it the value can be coercible to TrueClass" do
      [1, '1', true, Object.new, :thruthy].each do |value|
        validator = AcceptanceValidatorTest.new({tos: value})

        validator.valid?.must_equal true
        validator.errors.must_be_empty
      end
    end

    it "isn't valid if it isn't equal to true" do
      [0, '0', false, nil, '', '  '].each do |value|
        validator = AcceptanceValidatorTest.new({tos: value})

        validator.valid?.must_equal false
        error = validator.errors.for(:tos)
        error.must_include Lotus::Validations::Error.new(
          attribute_name: :tos,
          validation: :acceptance,
          expected: true,
          actual: value,
          validator_name: 'acceptance_validator_test')
      end
    end
  end
end
