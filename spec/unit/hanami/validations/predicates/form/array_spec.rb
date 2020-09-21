# frozen_string_literal: true
RSpec.describe "Predicates: Array" do
  include_context "validator result"

  describe "with required" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          required(:foo) { array? { each { int? } } }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { "foo" => ["3"] } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with missing input" do
      let(:input) { {} }

      it "is not successful" do
        expect_not_successful result, ["is missing"]
      end
    end

    describe "with nil input" do
      let(:input) { { "foo" => nil } }

      it "is not successful" do
        expect_not_successful result, ["must be an array"]
      end
    end

    describe "with blank input" do
      let(:input) { { "foo" => "" } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid type" do
      let(:input) { { "foo" => { "a" => "1" } } }

      it "is not successful" do
        expect_not_successful result, ["must be an array"]
      end
    end

    describe "with invalid input (integer)" do
      let(:input) { { "foo" => "4" } }

      it "is not successful" do
        expect_not_successful result, ["must be an array"]
      end
    end

    describe "with invalid input (array with non-integers)" do
      let(:input) { { "foo" => %w[foo bar] } }

      it "is not successful" do
        expect_not_successful result, 0 => ["must be an integer"], 1 => ["must be an integer"]
      end
    end

    describe "with invalid input (mixed array)" do
      let(:input) { { "foo" => %w[1 bar] } }

      it "is not successful" do
        expect_not_successful result, 1 => ["must be an integer"]
      end
    end
  end

  describe "with optional" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          optional(:foo) { included_in?(%w[1 3 5]) }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { "foo" => "3" } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with missing input" do
      let(:input) { {} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with nil input" do
      let(:input) { { "foo" => nil } }

      it "is not successful" do
        expect_not_successful result, ["must be one of: 1, 3, 5"]
      end
    end

    describe "with blank input" do
      let(:input) { { "foo" => "" } }

      it "is not successful" do
        expect_not_successful result, ["must be one of: 1, 3, 5"]
      end
    end

    describe "with invalid type" do
      let(:input) { { "foo" => { "a" => "1" } } }

      it "is not successful" do
        expect_not_successful result, ["must be one of: 1, 3, 5"]
      end
    end

    describe "with invalid input" do
      let(:input) { { "foo" => "4" } }

      it "is not successful" do
        expect_not_successful result, ["must be one of: 1, 3, 5"]
      end
    end
  end

  describe "as macro" do
    describe "with required" do
      before do
        @validator = Class.new do
          include Hanami::Validations::Form

          validations do
            required(:foo).each(:int?)
          end
        end
      end

      describe "with missing input" do
        let(:input) { {} }

        it "is not successful" do
          expect_not_successful result, ["is missing"]
        end
      end

      describe "with nil input" do
        let(:input) { { "foo" => nil } }

        it "is not successful" do
          expect_not_successful result, ["must be an array"]
        end
      end

      describe "with blank input" do
        let(:input) { { "foo" => "" } }

        it "is successful" do
          expect_successful result
        end
      end

      describe "with valid input" do
        let(:input) { { "foo" => ["3"] } }

        it "is successful" do
          expect_successful result
        end
      end

      describe "with invalid input" do
        let(:input) { { "foo" => ["bar"] } }

        it "is not successful" do
          expect_not_successful result, 0 => ["must be an integer"]
        end
      end
    end

    describe "with optional" do
      before do
        @validator = Class.new do
          include Hanami::Validations::Form

          validations do
            optional(:foo).each(:int?)
          end
        end
      end

      describe "with missing input" do
        let(:input) { {} }

        it "is not successful" do
          expect_successful result
        end
      end

      describe "with nil input" do
        let(:input) { { "foo" => nil } }

        it "is not successful" do
          expect_not_successful result, ["must be an array"]
        end
      end

      describe "with blank input" do
        let(:input) { { "foo" => "" } }

        it "is successful" do
          expect_successful result
        end
      end

      describe "with valid input" do
        let(:input) { { "foo" => ["3"] } }

        it "is successful" do
          expect_successful result
        end
      end

      describe "with invalid input" do
        let(:input) { { "foo" => ["bar"] } }

        it "is not successful" do
          expect_not_successful result, 0 => ["must be an integer"]
        end
      end
    end
  end
end
