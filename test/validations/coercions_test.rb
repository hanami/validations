require 'test_helper'
require 'lotus/validations/coercions'

describe Lotus::Validations::Coercions do
  describe 'Lotus::Utils::Kernel coercions' do
    it 'coerces value' do
      result = Lotus::Validations::Coercions.coerce(Boolean, 1)
      result.must_equal true
    end
  end

  describe 'custom coercions' do
    it 'coerces custom class' do
      result = Lotus::Validations::Coercions.coerce(FullName, 'Luca', 'Guidi')

      result.must_be_kind_of(FullName)
      result.to_s.must_equal 'Luca Guidi'
    end
  end

  describe 'nested params' do
    it "is valid when chlid is valid" do
      validator = NestedValidationTest.new(user: {name: 'L', age: '32'})

      validator.valid?.must_equal true
      validator.instance_variable_get(:@attributes)[:user].valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "isn't valid when chlid is unvalid" do
      validator = NestedValidationTest.new(user: {name: 'L'})

      validator.valid?.must_equal false
      validator.instance_variable_get(:@attributes)[:user].valid?.must_equal false
      errors = validator.errors.for(:user).first.actual.errors
      errors.for(:age).must_include Lotus::Validations::Error.new(:age, :presence, true, nil)
    end
  end
end
