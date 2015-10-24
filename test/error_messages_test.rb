require 'test_helper'

describe 'Error messages' do
  it "returns default error message" do
    validator = PresenceValidatorTest.new({})
    validator.valid?

    message = validator.errors.for(:name).first.to_s
    message.must_equal 'Name must be present'
  end

  it "returns default error message for nested attributes" do
    validator = NestedValidations.new({})
    validator.valid?

    message = validator.errors.for('address.line_one').first.to_s
    message.must_equal 'Line one must be present'
  end

  it "ignores different lang when for default message error" do
    I18n.locale = :it

    begin
      validator = PresenceValidatorTest.new({})
      validator.valid?

      message = validator.errors.for(:name).first.to_s
      message.must_equal 'Name must be present'
    ensure
      I18n.locale = :en
    end
  end

  it "returns customized error" do
    validator = AcceptanceValidatorTest.new({})
    validator.valid?

    message = validator.errors.for(:tos).first.to_s
    message.must_equal 'Please accept our Terms of Service'
  end

  # it "returns customized error for nested attributes"
  it "returns customized error for nested attributes" do
    validator = NestedValidations.new({address: {post_code: 'x'}})
    validator.valid?.must_equal false

    message = validator.errors.for('address.post_code').last.to_s
    message.must_equal 'Post code must be of five numbers'
  end

  it "returns customized error with different lang" do
    I18n.locale = :it

    begin
      validator = AcceptanceValidatorTest.new({})
      validator.valid?

      message = validator.errors.for(:tos).first.to_s
      message.must_equal 'Per favore accetta i nostri termini di servizio'
    ensure
      I18n.locale = :en
    end
  end
end
