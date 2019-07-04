# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe "inheritance" do
    subject do
      Class.new(base) do
        params do
          required(:user).hash do
            required(:name).filled(:string)
          end
        end
      end.new
    end

    let(:base) do
      Class.new(described_class) do
        params do
          optional(:_csrf_token).filled(:string)
        end
      end
    end

    it "inherits rules" do
      result = subject.call(user: { name: "Luca" })
      expect(result).to be_success
      expect(result.to_h).to eq(user: { name: "Luca" })

      result = subject.call(user: { name: "Luca" }, _csrf_token: "abc123")
      expect(result).to be_success
      expect(result.to_h).to eq(user: { name: "Luca" }, _csrf_token: "abc123")

      result = subject.call(user: { name: "Luca" }, _csrf_token: 123)
      expect(result).to_not be_success
      expect(result.to_h).to eq(user: { name: "Luca" }, _csrf_token: 123)
      expect(result.errors[:_csrf_token]).to match_array(["must be a string"])

      result = subject.call(_csrf_token: "abc123")
      expect(result).to_not be_success
      expect(result.to_h).to eq(_csrf_token: "abc123")
    end
  end
end
