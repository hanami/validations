require 'test_helper'

describe Lotus::Validations do
  describe 'inclusion' do
    it "is valid if attribute value is included in specified enumerable" do
      validator = InclusionValidatorTest.new(job: 'Carpenter', age: '42', state: 'ma', sport: 'Football', code: 'y')

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "is valid if attribute value is missing" do
      validator = InclusionValidatorTest.new(job: 'Carpenter')

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "isn't valid if attribute value is not included in specified enumerable" do
      validator = InclusionValidatorTest.new(job: 'Weaver', age: '42')

      validator.valid?.must_equal false
      error = validator.errors.for(:job)
      error.must_include Lotus::Validations::Error.new(:inclusion, ['Carpenter', 'Blacksmith'], 'Weaver')
    end
  end
end
