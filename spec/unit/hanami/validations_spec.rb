# frozen_string_literal: true

RSpec.describe Hanami::Validations do
  describe ".validations" do
    subject do
      Class.new do
        include Hanami::Validations

        validations do
          required(:number).filled(:integer, eql?: 23)
        end
      end
    end

    it "validates input" do
      result = subject.new(number: 23).validate

      expect(result).to be_success
      expect(result.errors).to be_empty

      expect(result.to_h).to eq(number: 23)
    end
  end
end
