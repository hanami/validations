require 'test_helper'

describe Lotus::Validations do
  it "is valid if the value is foo" do
    validator = UserDefinedValidatorTest.new(bar: 'foo')

    validator.valid?.must_equal true
    validator.errors.must_be_empty
  end

  it "is invalid if the value is not foo" do
    validator = UserDefinedValidatorTest.new(bar: 'zoo')

    validator.valid?.must_equal false
    validator.errors.wont_be_empty
  end

  it "has an error for the violation" do
    validator = UserDefinedValidatorTest.new(bar: 'zoo')

    validator.valid?.must_equal false
    errors = validator.errors.for(:bar)
    expected = Lotus::Validations::Error.new(:bar, :is_foo, 'foo', 'zoo')
    errors.must_include expected
  end
end
