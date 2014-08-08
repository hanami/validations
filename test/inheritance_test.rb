require 'test_helper'

describe Lotus::Validations do
  describe 'inheritance' do
    it "the superclass is able to validate" do
      superclass = SuperclassValidatorTest.new({})

      superclass.valid?.must_equal false
      superclass.errors.for(:name).must_include Lotus::Validations::Error.new(:name, :presence, true, nil)
    end

    it "the superclass doesn't receive validators from the subclass" do
      superclass = SuperclassValidatorTest.new({name: 'L'})

      superclass.valid?.must_equal true
      superclass.errors.must_be_empty

      superclass.wont_respond_to(:age)
    end

    it "the subclass receive validators from the superclass" do
      subclass = SuperclassValidatorTest.new({age: 32})

      subclass.valid?.must_equal false
      subclass.errors.for(:name).must_include Lotus::Validations::Error.new(:name, :presence, true, nil)
    end
  end
end
