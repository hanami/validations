# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe ".option" do
    subject do
      Class.new(described_class) do
        option :address_validator

        schema do
          required(:address).filled(:string)
        end

        rule(:address) do
          key.failure("not a valid address") unless address_validator.valid?(values[:address])
        end
      end.new(address_validator: address_validator)
    end

    let(:address_validator) do
      Class.new do
        def valid?(value)
          value.match(/Rome/)
        end
      end.new
    end

    it "validates input" do
      result = subject.call(address: "Rome")
      expect(result).to be_success
      expect(result.to_h).to eq(address: "Rome")

      result = subject.call(address: "foo")
      expect(result).to_not be_success
      expect(result.to_h).to eq(address: "foo")
      expect(result.errors[:address]).to match_array(["not a valid address"])
    end
  end
end
