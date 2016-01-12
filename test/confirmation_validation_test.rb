require 'test_helper'

describe Lotus::Validations do
  describe 'confirmation' do
    it "is valid when the attributes are missing" do
      validator = ConfirmationValidatorTest.new({})

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "is valid when the two attributes are matching" do
      validator = ConfirmationValidatorTest.new({ password: 'secret', password_confirmation: 'secret' })

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "isn't valid when only one attribute is present" do
      validator = ConfirmationValidatorTest.new({ password: 'secret' })

      validator.valid?.must_equal false
      error = validator.errors.for(:password)
      error.must_include Lotus::Validations::Error.new(
        attribute_name: :password,
        validation: :confirmation,
        expected: true,
        actual: 'secret',
        validator_name: 'confirmation_validator_test')
    end

    it "isn't valid when the two attributes aren't matching" do
      validator = ConfirmationValidatorTest.new({ password: 'secret', password_confirmation: 'x' })

      validator.valid?.must_equal false
      error = validator.errors.for(:password)
      error.must_include Lotus::Validations::Error.new(
        attribute_name: :password,
        validation: :confirmation,
        expected: true,
        actual: 'secret',
        validator_name: 'confirmation_validator_test')
    end
  end
end
