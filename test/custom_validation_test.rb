require 'test_helper'

describe Lotus::Validations, 'custom validations' do
  describe '#validate keyword' do
    it "can mimic presence validator" do
      validator = CustomPresenceValidation.new(name: '')
      validator.valid?.must_equal false
      validator.name = "X"
      validator.valid?.must_equal true
    end
  end

  describe '#validate keyword' do
    it "can mimic presence validator" do
      validator = CustomAttributesValidation.new(name: '')
      validator.valid?.must_equal false
      validator.name = "X"
      validator.valid?.must_equal true
    end
  end

end
