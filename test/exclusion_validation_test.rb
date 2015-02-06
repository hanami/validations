require 'test_helper'

describe Lotus::Validations do
  describe 'exclusion' do
    it "is valid if attribute value is escluded in specified enumerable" do
      validator = ExclusionValidatorTest.new(job: 'Programmer', age: '17', state: 'RM', sport: 'Snorkeling', code: 'j')
      
      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "is valid if attribute value is missing" do
      validator = ExclusionValidatorTest.new({})

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "isn't valid if attribute value is not included in specified enumerable" do
      validator = ExclusionValidatorTest.new(job: 'Carpenter')

      validator.valid?.must_equal false
      error = validator.errors.for(:job)
      error.must_include Lotus::Validations::Error.new(:exclusion, ['Carpenter', 'Blacksmith'], 'Carpenter')
    end
  end
end
