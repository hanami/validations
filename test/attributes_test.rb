require 'test_helper'

describe Lotus::Validations do
  describe '#attributes' do
    before do
      @validator = VisibilityValidatorTest.new(name: 'Luca')
    end

    it "doesn't allow external access" do
      -> { @validator.attributes }.must_raise(NoMethodError)
    end

    it "allows internal access with self" do
      @validator.get_attributes.must_equal({name: 'Luca'})
    end
  end
end
