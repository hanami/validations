require 'test_helper'

describe Hanami::Validations do
  describe '#initialize' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          key(:attr) { type?(Integer) }
        end
      end

      @nested = Class.new do
        include Hanami::Validations

        validations do
          key(:foo) { filled? }
          key(:num) { type?(Integer) & eql?(23) }

          key(:bar).schema do
            key(:baz) { filled? }
          end
        end
      end

      @params = Class.new do
        def initialize(attributes)
          @attributes = Hash[*attributes]
        end

        def to_h
          @attributes.to_h
        end
      end
    end

    it 'returns a value for the given attribute' do
      validator = @validator.new(attr: 23)
      validator.to_h.fetch(:attr).must_equal 23
    end

    it 'returns nil when not set' do
      validator = @validator.new({})
      validator.to_h.fetch(:attr, :missing).must_equal :missing
    end

    it 'accepts any object that implements #to_h' do
      params    = @params.new([:attr, 23])
      validator = @validator.new(params)

      validator.to_h.fetch(:attr).must_equal 23
    end

    it "doesn't modify the original attributes" do
      data       = { attr: '23' }
      validator  = @validator.new(data)
      validator.validate

      data[:attr].must_equal('23')
    end

    it 'accepts symbols as keys, without coercing and whitelisting' do
      validator = @nested.new(
        foo:     'ok',
        num:     23,
        unknown: 'no',
        bar: {
          baz: 'yo',
          wat: 'oh'
        }
      )

      result = validator.validate

      result.must_be :success?
      result.output.must_equal(
        foo:     'ok',
        num:     23,
        unknown: 'no',
        bar: {
          baz: 'yo',
          wat: 'oh'
        }
      )

      validator.to_h.must_equal(result.output)
    end
  end
end
