# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe "base validations" do
    subject do
      Class.new(Hanami::Validator) do
        validations do
          required(:number).filled(:int?, eql?: 23)
        end
      end.new
    end

    it "returns successful validation result with bare minimum valid data" do
      result = subject.call(number: 23)

      expect(result).to be_successful
      expect(result.to_h).to eq(number: 23)
    end

    it "returns successful validation result with full valid data" do
      result = subject.call(number: 23, _csrf_token: "abc")

      expect(result).to be_successful
      expect(result.to_h).to eq(number: 23, _csrf_token: "abc")
    end

    it "returns failing validation result with bare minimum invalid data" do
      result = subject.call(number: 11)

      expect(result).to be_failing
      expect(result.messages.fetch(:number)).to eq          ["must be equal to 23"]
      expect(result.messages.fetch(:_csrf_token, [])).to eq []

      expect(result.to_h).to eq(number: 11)
    end

    xit "returns failing validation result with full invalid data" do
      result = subject.call(number: 8, _csrf_token: "")

      expect(result).to be_failing
      expect(result.messages.fetch(:number)).to eq      ["must be equal to 23"]
      expect(result.messages.fetch(:_csrf_token)).to eq ["must be filled"]

      expect(result.to_h).to eq(number: 8, _csrf_token: "")
    end

    xit "returns failing validation result with base invalid data" do
      result = subject.call(number: 23, _csrf_token: "")

      expect(result).to be_failing
      expect(result.messages.fetch(:number, [])).to eq  []
      expect(result.messages.fetch(:_csrf_token)).to eq ["must be filled"]

      expect(result.to_h).to eq(number: 23, _csrf_token: "")
    end

    it "returns failing validation result for invalid data" do
      result = subject.call({})

      expect(result).to be_failing
      expect(result.messages.fetch(:number)).to eq          ["is missing", "must be equal to 23"]
      expect(result.messages.fetch(:_csrf_token, [])).to eq []

      expect(result.to_h).to eq({})
    end
  end
end
