# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe ".json" do
    let(:subject) do
      Class.new(described_class) do
        json do
          required(:email).value(:string)
          required(:age).value(:integer)
        end
      end.new
    end

    it "validates input" do
      result = subject.call("email" => "user@hanami.test", "age" => 21)

      expect(result).to be_success
      expect(result.to_h).to eq(email: "user@hanami.test", age: 21)
    end

    it "returns error when input is invalid" do
      result = subject.call("email" => "user@hanami.test", "age" => "21")

      expect(result).to_not be_success
      expect(result.to_h).to eq(email: "user@hanami.test", age: "21")
      expect(result.errors[:age]).to match_array(["must be an integer"])
    end
  end
end
