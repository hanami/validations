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
      params    = Params.new([:attr, 23])
      validator = InitializerTest.new(params)

      validator.attr.must_equal 23
    end

    it "doesn't modify the original attributes" do
      attributes = { attr: '23' }
      validator  = InitializerTest.new(attributes)
      validator.valid?

      attributes[:attr].must_equal('23')
    end

    it "doesn't pollute other validators with the getters" do
      validator = AnotherValidator.new(another: 11)
      validator.wont_respond_to(:attr)

      @validator.wont_respond_to(:another)
    end

    it "accepts strings as keys, only for the defined attributes" do
      validator = Signup.new(
        'email'                 => 'user@example.org',
        'password'              => '123',
        'password_confirmation' => '123',
        'unknown'               => 'blah'
      )

      validator.must_be :valid?

      validator.to_h.must_equal({ email: 'user@example.org', password: '123', password_confirmation: '123' })
    end

    it "whitelists attributes on initialize" do
      validator = UndefinedAttributesValidator.new('a' => 1, :b => 2, :name => 'test')

      validator.must_be :valid?
      validator.to_h.must_equal({ name: 'test' })

      validator['a'].must_be_nil
      validator['b'].must_be_nil
    end
  end
end
