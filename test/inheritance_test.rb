require 'test_helper'

describe Lotus::Validations do
  describe 'inheritance' do
    it "the superclass is able to validate" do
      error = Lotus::Validations::Error.new(
        attribute_name: :name,
        validation: :presence,
        expected: true,
        validator_name: 'superclass_validator_test')
      superclass = SuperclassValidatorTest.new({})

      superclass.valid?.must_equal false
      superclass.errors.for(:name).must_include error
    end

    it "the superclass doesn't receive validators from the subclass" do
      superclass = SuperclassValidatorTest.new({name: 'L'})

      superclass.valid?.must_equal true
      superclass.errors.must_be_empty

      superclass.wont_respond_to(:age)
    end

    it "the subclass receive validators from the superclass" do
      error = Lotus::Validations::Error.new(
        attribute_name: :name,
        validation: :presence,
        expected: true,
        validator_name: 'subclass_validator_test')
      subclass = SubclassValidatorTest.new({age: 32})

      subclass.valid?.must_equal false
      subclass.errors.for(:name).must_include error
    end

    it "receives attributes from the super class" do
      subclass = SubclassValidatorTest.new({age: 32, name: 'Luca'})
      subclass.to_h.must_equal({age: 32, name: 'Luca'})
    end
  end
end
