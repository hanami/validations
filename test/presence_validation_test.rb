require 'test_helper'

describe Lotus::Validations do
  describe 'presence' do
    it "is valid if missing an optional attribute" do
      validator = PresenceValidatorTest.new(name: 'L', age: '32')

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "isn't valid if missing an required attribute" do
      validator = PresenceValidatorTest.new(name: 'L')

      validator.valid?.must_equal false
      error = validator.errors.fetch(:age)
      error.must_equal Hash[presence: [true, nil]]
    end
  end
end
