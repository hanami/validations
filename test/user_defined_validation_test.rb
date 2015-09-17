require 'test_helper'

describe Lotus::Validations do
  it "is valid if block returns true" do
    validator = UserDefinedValidationTest.new(foo: 'bar')

    validator.valid?.must_equal true
    validator.errors.must_be_empty
  end

  it "is invalid if block returns false" do
    validator = UserDefinedValidationTest.new(foo: 'zoo')

    validator.valid?.must_equal false
    validator.errors.wont_be_empty
  end

  it "has an error for the violation" do
    validator = UserDefinedValidationTest.new(foo: 'zoo')

    validator.valid?.must_equal false
    errors = validator.errors.for(:foo)
    expected = Lotus::Validations::Error.new(:foo, :is_bar, false, 'zoo')
    errors.must_include expected
  end
end
