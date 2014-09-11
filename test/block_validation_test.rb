require 'test_helper'

describe Lotus::Validations do
  describe 'block' do
    it "is valid if it doesn't have attributes" do
      validator = BlockValidatorTest.new({})

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "is valid if it respects given block" do
      validator = BlockValidatorTest.new(name: 'foo')

      validator.valid?.must_equal true
      validator.errors.must_be_empty
      validator.attributes[:name] = 'foo'
    end

    it "rewrite value if block have second return value" do
      validator = BlockValidatorTest.new(name: 'foo')

      validator.valid?.must_equal true
      validator.errors.must_be_empty
      validator.attributes[:name] = 'FOO'
    end

    it "isn't valid if one doesn't respect given formats" do
      validator = BlockValidatorTest.new(name: 'baz')

      validator.valid?.must_equal false
      error = validator.errors.for(:name)
      error.must_include Lotus::Validations::Error.new(:name, :block, 'foo or bar', 'baz')
    end
  end
end
