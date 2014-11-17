require 'test_helper'

describe Lotus::Validations do
  before do
    @validator = VisibilityValidatorTest.new(name: 'Luca', unwanted: 'nope', password: 'secret', password_confirmation: 'secret')
  end

  describe '#_attributes' do
    it "doesn't allow external access" do
      -> { @validator._attributes }.must_raise(NoMethodError)
    end

    it "allows internal access with self" do
      @validator.get_attributes.must_equal({name: 'Luca', password: 'secret', password_confirmation: 'secret'})
    end
  end

  describe '#attributes' do
    it 'makes the set of attributes available' do
      @validator.attributes.must_equal({name: 'Luca', password: 'secret', password_confirmation: 'secret'})
    end

    it 'prevents information escape' do
      @validator.attributes[:name].reverse!

      @validator.attributes.must_equal({name: 'Luca', password: 'secret', password_confirmation: 'secret'})
      @validator.get_attributes.must_equal({name: 'Luca', password: 'secret', password_confirmation: 'secret'})
    end
  end

  describe '#to_h' do
    it 'makes the set of attributes available' do
      @validator.to_h.must_equal({name: 'Luca', password: 'secret', password_confirmation: 'secret'})
    end

    it 'prevents information escape' do
      @validator.to_h[:name].reverse!
      @validator.to_h.must_equal({name: 'Luca', password: 'secret', password_confirmation: 'secret'})
    end
  end
end
