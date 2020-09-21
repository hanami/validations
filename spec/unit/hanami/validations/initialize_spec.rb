# frozen_string_literal: true
RSpec.describe Hanami::Validations do
  describe '#initialize' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          required(:attr) { type?(Integer) }
        end
      end

      @nested = Class.new do
        include Hanami::Validations

        validations do
          required(:foo) { filled? }
          required(:num) { type?(Integer) & eql?(23) }

          required(:bar).schema do
            required(:baz) { filled? }
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
      expect(validator.to_h.fetch(:attr)).to eq 23
    end

    it 'returns nil when not set' do
      validator = @validator.new({})
      expect(validator.to_h.fetch(:attr, :missing)).to eq :missing
    end

    it 'accepts any object that implements #to_h' do
      params    = @params.new([:attr, 23])
      validator = @validator.new(params)

      expect(validator.to_h.fetch(:attr)).to eq 23
    end

    it 'accepts zero arguments' do
      validator = @validator.new
      expect(validator.to_h).to eq({})
    end

    it "doesn't modify the original attributes" do
      data       = { attr: '23' }
      validator  = @validator.new(data)
      validator.validate

      expect(data[:attr]).to eq('23')
    end

    it 'accepts symbols as keys, without coercing and whitelisting' do
      validator = @nested.new(
        foo: 'ok',
        num: 23,
        unknown: 'no',
        bar: {
          baz: 'yo',
          wat: 'oh'
        }
      )

      result = validator.validate

      expect(result).to be_success
      expect(result.output).to eq(
        foo: 'ok',
        num: 23,
        unknown: 'no',
        bar: {
          baz: 'yo',
          wat: 'oh'
        }
      )

      expect(validator.to_h).to eq(result.output)
    end
  end
end
