# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  let(:subject) do
    Class.new(described_class) do
      schema do
        required(:number).filled(:int?, eql?: 23)
      end
    end.new
  end

  describe "#initialize" do
    it "returns a new instance" do
      expect(subject).to be_kind_of(described_class)
      # expect(subject).to be_frozen
    end
  end

  describe "#call" do
    it "validates input" do
      result = subject.call(number: 23)

      expect(result).to be_kind_of(Dry::Validation::Result)
      expect(result.success?).to be(true)
      expect(result.errors).to be_kind_of(Dry::Validation::MessageSet)
      expect(result.errors.empty?).to be(true)
    end

    it "returns validation errors" do
      result = subject.call(number: "foo")

      expect(result).to be_kind_of(Dry::Validation::Result)
      expect(result.success?).to be(false)
      expect(result.errors).to be_kind_of(Dry::Validation::MessageSet)
      expect(result.errors.empty?).to be(false)

      expect(result.errors.to_h).to eq(number: ["must be an integer"])

      errors = result.errors.map(&:text)

      expect(errors).to match_array(["must be an integer"])
    end
  end
end
