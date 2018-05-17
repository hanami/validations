# frozen_string_literal: true

RSpec.describe "Messages" do
  describe "with anonymous class" do
    subject do
      Class.new(Hanami::Validator) do
        validations do
          configure do
            config.messages_file = "spec/support/fixtures/messages.yml"
            config.namespace     = :foo
          end

          required(:age).filled(:int?, gt?: 18)
        end
      end.new
    end

    it "returns configured message" do
      result = subject.call(age: 11)

      expect(result).to be_failing
      expect(result.messages.fetch(:age)).to eq(["must be an adult"])
    end
  end

  describe "with concrete class" do
    subject { SignupValidator.new }

    xit "returns configured message" do
      result = subject.call(age: 11)

      expect(result).to be_failing
      expect(result.messages.fetch(:age)).to eq(["must be an adult"])
    end
  end

  describe "with concrete namespaced class" do
    subject { Web::Controllers::Signup::Create::Params.new }

    xit "returns configured message" do
      result = subject.call(age: 11)

      expect(result).to be_failing
      expect(result.messages.fetch(:age)).to eq(["must be an adult"])
    end
  end

  describe "with i18n support" do
    subject { DomainValidator.new }

    xit "returns configured message" do
      result = subject.call(name: "a" * 256)

      expect(result).to be_failing
      expect(result.messages.fetch(:name)).to eq(["is too long"])
    end
  end

  describe "with i18n support and shared predicates" do
    subject { ChangedTermsOfServicesValidator.new }

    xit "returns configured message" do
      result = subject.call(terms: "false")

      expect(result).to be_failing
      expect(result.messages.fetch(:terms)).to eq(["must be accepted"])
    end
  end
end
