# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe ".schema" do
    let(:subject) do
      Class.new(described_class) do
        schema do
          required(:email).value(:string)
          required(:age).value(:integer)
        end
      end.new
    end

    it "ignores unexpected input" do
      result = subject.call(unexpected: :reality, age: 21)

      expect(result.to_h).to eq(age: 21)
      expect(result.errors.to_h).to eq(email: ["is missing"])
    end
  end
end
