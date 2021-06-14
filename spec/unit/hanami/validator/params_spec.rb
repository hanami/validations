# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe ".params" do
    let(:subject) do
      Class.new(described_class) do
        params do
          required(:email).value(:string)
          required(:age).value(:integer)
        end
      end.new
    end

    it "coerces input" do
      result = subject.call("email" => "user@hanami.test", "age" => "21")

      expect(result).to be_success
      expect(result.to_h).to eq(email: "user@hanami.test", age: 21)
    end

    it "gives up when input cannot be coerced" do
      result = subject.call("email" => "user@hanami.test", "age" => ["foo"])

      expect(result).to_not be_success
      expect(result.to_h).to eq(email: "user@hanami.test", age: ["foo"])
      expect(result.errors[:age]).to match_array(["must be an integer"])
    end
  end
end
