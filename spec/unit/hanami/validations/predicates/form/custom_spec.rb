# frozen_string_literal: true

RSpec.describe "Predicates: custom" do
  include_context "validator result"

  describe "with custom predicate" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        def self.name
          "Validator"
        end

        validations do
          configure do
            config.messages_file = "spec/support/fixtures/messages.yml"

            def email?(current)
              current.match(/\@/)
            end
          end

          required(:foo) { email? }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { foo: "test@hanamirb.org" } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { { foo: "test" } }

      it "is not successful" do
        expect_not_successful result, ["must be an email"]
      end
    end
  end

  describe "with custom predicates as module" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        def self.name
          "Validator"
        end

        predicates(
          Module.new do
            include Hanami::Validations::Predicates
            self.messages_path = "spec/support/fixtures/messages.yml"

            predicate(:email?) do |current|
              current.match(/@/)
            end
          end
        )

        validations do
          required(:foo) { email? }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { foo: "test@hanamirb.org" } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { { foo: "test" } }

      it "is not successful" do
        expect_not_successful result, ["must be an email"]
      end
    end
  end

  describe "with custom predicate within predicates block" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        def self.name
          "Validator"
        end

        predicate :url?, message: "must be an URL" do |current|
          current.start_with?("http")
        end

        validations do
          required(:foo) { url? }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { foo: "http://hanamirb.org" } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { { foo: "test" } }

      it "is successful" do
        expect_not_successful result, ["must be an URL"]
      end
    end
  end

  describe "with custom predicate with predicate macro" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        def self.name
          "Validator"
        end

        predicate :api_date?, message: "must be in iso8601 format" do |value|
          Date.iso8601(value)
          true
        rescue ArgumentError
          false
        end

        validations do
          required(:id).filled
          required(:confirmed_at).filled(:api_date?)
        end
      end
    end

    describe "with valid data" do
      let(:input) { { id: 1, confirmed_at: Date.today.iso8601 } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid data" do
      let(:input) { { id: 1, confirmed_at: "foo" } }

      it "is not successful" do
        expect_not_successful result, ["must be in iso8601 format"], :confirmed_at
      end
    end
  end

  describe "without custom predicate" do
    it "raises error if try to use an unknown predicate" do
      expect do
        Class.new do
          include Hanami::Validations::Form

          def self.name
            "Validator"
          end

          validations do
            required(:foo) { email? }
          end
        end
      end.to raise_error(ArgumentError, "+email?+ is not a valid predicate name")
    end
  end

  describe "with nested validations" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        def self.name
          "Validator"
        end

        validations do
          required(:details).schema do
            configure do
              config.messages_file = "spec/support/fixtures/messages.yml"

              def odd?(current)
                current.odd?
              end
            end

            required(:foo) { odd? }
          end
        end
      end
    end

    it "allows groups to define their own custom predicates" do
      result = @validator.new(details: { foo: 2 }).validate

      expect(result).not_to be_success
      expect(result.messages[:details][:foo]).to eq ["must be odd"]
    end
  end
end
