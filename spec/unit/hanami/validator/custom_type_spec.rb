# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe "custom type" do
    let(:subject) do
      module Types
        include Dry::Types()

        StrippedString = Types::String.constructor(&:strip)
      end

      Class.new(described_class) do
        json do
          required(:email).value(Types::StrippedString)
          required(:age).value(:integer)
        end
      end.new
    end

    it "validates input" do
      result = subject.call("email" => "       user@hanami.test", "age" => 21)

      expect(result).to be_success
      expect(result.to_h).to eq(email: "user@hanami.test", age: 21)
    end
  end
end
