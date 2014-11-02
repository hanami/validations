require 'test_helper'

describe Lotus::Validations do
  before do
    @validator = VisibilityValidatorTest.new(name: 'Luca')
  end

  describe '#_attributes' do
    it "doesn't allow external access" do
      -> { @validator._attributes }.must_raise(NoMethodError)
    end

    it "allows internal access with self" do
      @validator.get_attributes.must_equal({name: 'Luca'})
    end
  end

  describe '#attributes' do
    it 'makes the set of attributes available' do
      @validator.attributes.must_equal({name: 'Luca'})
    end

    it 'prevents information escape' do
      @validator.attributes[:name].reverse!

      @validator.attributes.must_equal({name: 'Luca'})
      @validator.get_attributes.must_equal({name: 'Luca'})
    end
  end
end
