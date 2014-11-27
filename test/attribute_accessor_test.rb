require 'test_helper'

describe Lotus::Validations do
  describe 'attribute writer' do
    it 'test attribute name' do
      assert AttributeAccessorTest.defined_attribute?(:attr)
    end

    it 'test attribute write possibility' do
      obj = AttributeAccessorTest.new attr: 5
      obj.attr.must_equal 5

      obj.attr = 6
      obj.attr.must_equal 6
    end

    it 'test attribute valid and writable' do
      obj = WritablePresenceValidatorTest.new name: "Roberto"
      assert obj.valid?
      obj.name.must_equal "Roberto"

      obj.name = "Matteo"
      obj.name.must_equal "Matteo"
    end

  end
end