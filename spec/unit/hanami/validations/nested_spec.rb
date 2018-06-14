# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe "nested validations" do
    subject do
      Class.new(Hanami::Validator) do
        validations do
          required(:number) { filled? }
          required(:code) { filled? & eql?("foo") }

          required(:customer).schema do
            required(:name) { filled? }
            required(:code) { filled? & eql?("bar") }

            required(:address).schema do
              required(:city) { filled? }
            end
          end
        end
      end.new
    end

    it "returns successful validation result for valid data" do
      result = subject.call(number: 23, code: "foo", customer: { name: "Luca", code: "bar", address: { city: "Rome" } })

      expect(result).to be_successful
    end

    it "returns failing validation result for invalid data" do
      result = subject.call({})

      expect(result).not_to be_successful
      expect(result.messages.fetch(:number)).to eq ["is missing"]
      expect(result.messages.fetch(:customer)).to eq ["is missing"]
    end

    it "returns different failing validations for keys with the same name" do
      result = subject.call(code: "x", customer: { code: "y" })

      expect(result).not_to be_successful
      expect(result.messages.fetch(:code)).to eq ["must be equal to foo"]
      expect(result.messages.fetch(:customer).fetch(:code)).to eq ["must be equal to bar"]
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58
    it "safely serialize to nested Hash" do
      data      = { name: "John Smith", address: { line_one: "10 High Street" } }
      validator = subject.call(data)

      expect(validator.to_h).to eq(data)
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58#issuecomment-99144243
    it "safely serialize to Hash" do
      data      = { name: "John Smith", tags: [1, 2] }
      validator = subject.call(data)

      expect(validator.to_h).to eq(data)
    end
  end
end
