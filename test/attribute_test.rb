require 'test_helper'

describe Lotus::Validations do
  describe '.attribute' do
    it 'coerces attribute names to symbols' do
      AttributeTest.__send__(:attributes).keys.must_include(:attr)
    end

    it 'ensures attribute uniqueness' do
      UniquenessAttributeTest.__send__(:attributes).keys.must_include(:attr)
    end
  end
end
