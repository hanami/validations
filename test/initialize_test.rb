require 'test_helper'

describe Lotus::Validations do
  describe '#initialize' do
    before do
      @validator = InitializerTest.new(attr: 23)
    end

    it 'returns a value for the given attribute' do
      @validator.attr.must_equal 23
    end

    it 'returns nil when not set' do
      validator = AnotherValidator.new({})
      validator.another.must_be_nil
    end

    it 'accepts any object that implements #to_h' do
      params = Params.new([:attr, 23])
      validator = InitializerTest.new(params)

      validator.attr.must_equal 23
    end

    it "doesn't pollute other validators with the getters" do
      validator = AnotherValidator.new(another: 11)
      validator.wont_respond_to(:attr)

      @validator.wont_respond_to(:another)
    end
  end
end
