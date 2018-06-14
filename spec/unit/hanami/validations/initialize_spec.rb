# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe "#initialize" do
    subject do
      Class.new(Hanami::Validator) do
        validations do
          required(:attr) { type?(Integer) }
        end
      end.new
    end

    let(:nested) do
      Class.new(Hanami::Validator) do
        validations do
          required(:foo) { filled? }
          required(:num) { type?(Integer) & eql?(23) }

          required(:bar).schema do
            required(:baz) { filled? }
          end
        end
      end.new
    end

    let(:params) do
      Class.new do
        def initialize(attributes)
          @attributes = Hash[*attributes]
        end

        def to_hash
          @attributes
        end
      end
    end

    it "returns a frozen object" do
      expect(subject).to be_frozen
    end

    it "returns a value for the given attribute" do
      result = subject.call(attr: 23)
      expect(result.to_h.fetch(:attr)).to eq(23)
    end

    it "returns nil when not set" do
      validator = subject.call({})
      expect(validator.to_h.fetch(:attr, :missing)).to eq(:missing)
    end

    it "accepts any object that implements #to_h" do
      input  = params.new([:attr, 23])
      result = subject.call(input)

      expect(result.to_h.fetch(:attr)).to eq(23)
    end

    it "accepts zero arguments" do
      result = subject.call({})
      expect(result.to_h).to eq({})
    end

    it "doesn't modify the original attributes" do
      data = { attr: "23" }
      subject.call(data)

      expect(data[:attr]).to eq("23")
    end

    it "accepts symbols as keys, without coercing and whitelisting" do
      result = nested.call(
        foo:     "ok",
        num:     23,
        unknown: "no",
        bar: {
          baz: "yo",
          wat: "oh"
        }
      )

      expect(result).to be_successful
      expect(result.to_h).to eq(
        foo:     "ok",
        num:     23,
        unknown: "no",
        bar: {
          baz: "yo",
          wat: "oh"
        }
      )
    end
  end
end
