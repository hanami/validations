# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe "macro" do
    subject do
      Class.new(base) do
        schema do
          required(:email).filled(:string)
        end

        rule(:email).validate(:email_format)
      end.new
    end

    let(:base) do
      Class.new(described_class) do
        register_macro(:email_format) do
          key.failure("not a valid email format") unless /@/ =~ value
        end
      end
    end

    it "applies rule from macro" do
      result = subject.call(email: "user@hanami.test")
      expect(result).to be_success
      expect(result.to_h).to eq(email: "user@hanami.test")

      result = subject.call(email: "user")
      expect(result).to_not be_success
      expect(result.to_h).to eq(email: "user")
      expect(result.errors[:email]).to match_array(["not a valid email format"])
    end

    context "with options" do
      subject do
        Class.new(base) do
          schema do
            required(:phone_numbers).value(:array)
          end

          rule(:phone_numbers).validate(min_size: 1)
        end.new
      end

      let(:base) do
        Class.new(described_class) do
          register_macro(:min_size) do |macro:|
            min = macro.args[0]
            key.failure("must have at least #{min} elements") unless value.size >= min
          end
        end
      end

      it "applies rule from macro" do
        result = subject.call(phone_numbers: ["06"])
        expect(result).to be_success
        expect(result.to_h).to eq(phone_numbers: ["06"])

        result = subject.call(phone_numbers: [])
        expect(result).to_not be_success
        expect(result.to_h).to eq(phone_numbers: [])
        expect(result.errors[:phone_numbers]).to match_array(["must have at least 1 elements"])
      end
    end
  end
end
