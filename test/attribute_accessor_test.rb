require 'test_helper'

describe Lotus::Validations do
  describe 'attribute writer' do
    it 'test attribute name' do
      assert AttributeAccessorTest.defined_attribute?(:attr)
    end

    it 'test attribute write possibility' do
      obj = AttributeAccessorTest.new attr: 5
      assert_equal 5, obj.attr

      obj.attr = 6
      assert_equal 6, obj.attr
    end

    it 'test attribute valid and writable' do
      obj = WritablePresenceValidatorTest.new name: "Roberto"
      assert obj.valid?
      assert_equal "Roberto", obj.name

      obj.name = "Matteo"
      assert_equal "Matteo", obj.name
    end

  end
end