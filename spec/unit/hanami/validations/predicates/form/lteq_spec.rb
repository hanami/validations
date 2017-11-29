# frozen_string_literal: true

RSpec.describe "Predicates: Lteq" do
  include_context "validator result"

  describe "with required" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          required(:foo) { int? & lteq?(23) }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { "foo" => "1" } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with missing input" do
      let(:input) { {} }

      it "is not successful" do
        expect_not_successful result, ["is missing", "must be less than or equal to 23"]
      end
    end

    describe "with nil input" do
      let(:input) { { "foo" => nil } }

      it "is not successful" do
        expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
      end
    end

    describe "with blank input" do
      let(:input) { { "foo" => "" } }

      it "is not successful" do
        expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
      end
    end

    describe "with invalid input type" do
      let(:input) { { "foo" => [] } }

      it "is not successful" do
        expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
      end
    end

    describe "with equal input" do
      let(:input) { { "foo" => "23" } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with greater than input" do
      let(:input) { { "foo" => "99" } }

      it "is not successful" do
        expect_not_successful result, ["must be less than or equal to 23"]
      end
    end
  end

  describe "with optional" do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          optional(:foo) { int? & lteq?(23) }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { "foo" => "1" } }

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
        expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
      end
    end

    describe "with blank input" do
      let(:input) { { "foo" => "" } }

      it "is not successful" do
        expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
      end
    end

    describe "with invalid input type" do
      let(:input) { { "foo" => [] } }

      it "is not successful" do
        expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
      end
    end

    describe "with equal input" do
      let(:input) { { "foo" => "23" } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with greater than input" do
      let(:input) { { "foo" => "99" } }

      it "is not successful" do
        expect_not_successful result, ["must be less than or equal to 23"]
      end
    end
  end

  describe "as macro" do
    describe "with required" do
      describe "with value" do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).value(:int?, lteq?: 23)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { "foo" => "1" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with missing input" do
          let(:input) { {} }

          it "is not successful" do
            expect_not_successful result, ["is missing", "must be less than or equal to 23"]
          end
        end

        describe "with nil input" do
          let(:input) { { "foo" => nil } }

          it "is not successful" do
            expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
          end
        end

        describe "with blank input" do
          let(:input) { { "foo" => "" } }

          it "is not successful" do
            expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
          end
        end

        describe "with invalid input type" do
          let(:input) { { "foo" => [] } }

          it "is not successful" do
            expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
          end
        end

        describe "with equal input" do
          let(:input) { { "foo" => "23" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with greater than input" do
          let(:input) { { "foo" => "99" } }

          it "is not successful" do
            expect_not_successful result, ["must be less than or equal to 23"]
          end
        end
      end

      describe "with filled" do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).filled(:int?, lteq?: 23)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { "foo" => "1" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with missing input" do
          let(:input) { {} }

          it "is not successful" do
            expect_not_successful result, ["is missing", "must be less than or equal to 23"]
          end
        end

        describe "with nil input" do
          let(:input) { { "foo" => nil } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "must be less than or equal to 23"]
          end
        end

        describe "with blank input" do
          let(:input) { { "foo" => "" } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "must be less than or equal to 23"]
          end
        end

        describe "with invalid input type" do
          let(:input) { { "foo" => [] } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "must be less than or equal to 23"]
          end
        end

        describe "with equal input" do
          let(:input) { { "foo" => "23" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with greater than input" do
          let(:input) { { "foo" => "99" } }

          it "is not successful" do
            expect_not_successful result, ["must be less than or equal to 23"]
          end
        end
      end

      describe "with maybe" do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).maybe(:int?, lteq?: 23)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { "foo" => "1" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with missing input" do
          let(:input) { {} }

          it "is not successful" do
            expect_not_successful result, ["is missing", "must be less than or equal to 23"]
          end
        end

        describe "with nil input" do
          let(:input) { { "foo" => nil } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with blank input" do
          let(:input) { { "foo" => "" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with invalid input type" do
          let(:input) { { "foo" => [] } }

          it "is not successful" do
            expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
          end
        end

        describe "with equal input" do
          let(:input) { { "foo" => "23" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with greater than input" do
          let(:input) { { "foo" => "99" } }

          it "is not successful" do
            expect_not_successful result, ["must be less than or equal to 23"]
          end
        end
      end
    end

    describe "with optional" do
      describe "with value" do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).value(:int?, lteq?: 23)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { "foo" => "1" } }

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
            expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
          end
        end

        describe "with blank input" do
          let(:input) { { "foo" => "" } }

          it "is not successful" do
            expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
          end
        end

        describe "with invalid input type" do
          let(:input) { { "foo" => [] } }

          it "is not successful" do
            expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
          end
        end

        describe "with equal input" do
          let(:input) { { "foo" => "23" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with greater than input" do
          let(:input) { { "foo" => "99" } }

          it "is not successful" do
            expect_not_successful result, ["must be less than or equal to 23"]
          end
        end
      end

      describe "with filled" do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).filled(:int?, lteq?: 23)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { "foo" => "1" } }

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
            expect_not_successful result, ["must be filled", "must be less than or equal to 23"]
          end
        end

        describe "with blank input" do
          let(:input) { { "foo" => "" } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "must be less than or equal to 23"]
          end
        end

        describe "with invalid input type" do
          let(:input) { { "foo" => [] } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "must be less than or equal to 23"]
          end
        end

        describe "with equal input" do
          let(:input) { { "foo" => "23" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with greater than input" do
          let(:input) { { "foo" => "99" } }

          it "is not successful" do
            expect_not_successful result, ["must be less than or equal to 23"]
          end
        end
      end

      describe "with maybe" do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).maybe(:int?, lteq?: 23)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { "foo" => "1" } }

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

          it "is successful" do
            expect_successful result
          end
        end

        describe "with blank input" do
          let(:input) { { "foo" => "" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with invalid input type" do
          let(:input) { { "foo" => [] } }

          it "is not successful" do
            expect_not_successful result, ["must be an integer", "must be less than or equal to 23"]
          end
        end

        describe "with equal input" do
          let(:input) { { "foo" => "23" } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with greater than input" do
          let(:input) { { "foo" => "99" } }

          it "is not successful" do
            expect_not_successful result, ["must be less than or equal to 23"]
          end
        end
      end
    end
  end
end
