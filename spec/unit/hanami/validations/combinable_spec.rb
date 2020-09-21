# frozen_string_literal: true
RSpec.describe Hanami::Validations do
  describe "combinable validations" do
    before do
      address = Class.new do
        include Hanami::Validations

        validations do
          required(:city) { filled? }
        end
      end

      customer = Class.new do
        include Hanami::Validations

        validations do
          required(:name) { filled? }
          # FIXME: ask dry team to support any object that responds to #schema.
          required(:address).schema(address.schema)
        end
      end

      @order = Class.new do
        include Hanami::Validations

        validations do
          required(:number) { filled? }
          required(:customer).schema(customer.schema)
        end
      end
    end

    it "returns successful validation result for valid data" do
      result = @order.new(number: 23, customer: { name: "Luca", address: { city: "Rome" } }).validate
      expect(result).to be_success
      expect(result.errors).to be_empty
    end

    it "returns failing validation result for invalid data" do
      result = @order.new({}).validate

      expect(result).not_to be_success
      expect(result.messages.fetch(:number)).to eq   ["is missing"]
      expect(result.messages.fetch(:customer)).to eq ["is missing"]
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58
    it "safely serialize to nested Hash" do
      data      = { name: "John Smith", address: { line_one: "10 High Street" } }
      validator = @order.new(data)

      expect(validator.to_h).to eq(data)
    end

    # Bug
    # See https://github.com/hanami/validations/issues/58#issuecomment-99144243
    it "safely serialize to Hash" do
      data      = { name: "John Smith", tags: [1, 2] }
      validator = @order.new(data)

      expect(validator.to_h).to eq(data)
    end
  end
end
