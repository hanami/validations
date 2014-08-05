require 'test_helper'

describe Lotus::Validations do
  describe 'exclusion' do
    it "is valid if attribute is not included in specified enumerable" do
      validator = ExclusionValidatorTest.new({job: 'Miner', age: '32'}, {jobs: ['Carpenter']})

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "isn't valid if attribute is included in specified enumeriable" do
      validator = ExclusionValidatorTest.new({job: 'Carpenter', age: '32'}, {jobs: ['Carpenter']})

      validator.valid?.must_equal false
      validator.errors.fetch(:job).must_include :exclusion
    end
  end
end
