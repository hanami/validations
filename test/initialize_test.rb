require 'test_helper'

describe Lotus::Validations do
  describe '#initialize' do
    before do
      @validator = InitializerTest.new(attr: 23)
    end

    it 'returns a value for the given attribute' do
      @validator.attr.must_equal 23
    end

    it "doesn't pollute other validators with the getters" do
      validator = AnotherValidator.new(another: 11)
      validator.wont_respond_to(:attr)

      @validator.wont_respond_to(:another)
    end
  end
end
