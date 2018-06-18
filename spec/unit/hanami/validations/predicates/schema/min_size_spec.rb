# frozen_string_literal: true

RSpec.describe "Predicates: Min Size" do
  include_context "validator result"

  describe "with required" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          required(:foo) { min_size?(3) }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { foo: [1, 2, 3] } }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with missing input" do
      let(:input) { {} }

      it "is not successful" do
        expect_not_successful result, ["is missing", "size cannot be less than 3"]
      end
    end

    describe "with nil input" do
      let(:input) { { foo: nil } }

      it "is raises error" do
        expect { result }.to raise_error(NoMethodError)
      end
    end

    describe "with blank input" do
      let(:input) { { foo: "" } }

      it "is not successful" do
        expect_not_successful result, ["size cannot be less than 3"]
      end
    end

    describe "with invalid input" do
      let(:input) { { foo: { a: 1, b: 2 } } }

      it "is not successful" do
        expect_not_successful result, ["size cannot be less than 3"]
      end
    end
  end

  describe "with optional" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          optional(:foo) { min_size?(3) }
        end
      end
    end

    describe "with valid input" do
      let(:input) { { foo: [1, 2, 3] } }

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
      let(:input) { { foo: nil } }

      it "is raises error" do
        expect { result }.to raise_error(NoMethodError)
      end
    end

    describe "with blank input" do
      let(:input) { { foo: "" } }

      it "is not successful" do
        expect_not_successful result, ["size cannot be less than 3"]
      end
    end

    describe "with invalid input" do
      let(:input) { { foo: { a: 1, b: 2 } } }

      it "is not successful" do
        expect_not_successful result, ["size cannot be less than 3"]
      end
    end
  end

  describe "as macro" do
    describe "with required" do
      describe "with value" do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).value(min_size?: 3)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { foo: [1, 2, 3] } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with missing input" do
          let(:input) { {} }

          it "is not successful" do
            expect_not_successful result, ["is missing", "size cannot be less than 3"]
          end
        end

        describe "with nil input" do
          let(:input) { { foo: nil } }

          it "is raises error" do
            expect { result }.to raise_error(NoMethodError)
          end
        end

        describe "with blank input" do
          let(:input) { { foo: "" } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end

        describe "with invalid input" do
          let(:input) { { foo: { a: 1, b: 2 } } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end
      end

      describe "with filled" do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).filled(min_size?: 3)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { foo: [1, 2, 3] } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with missing input" do
          let(:input) { {} }

          it "is not successful" do
            expect_not_successful result, ["is missing", "size cannot be less than 3"]
          end
        end

        describe "with nil input" do
          let(:input) { { foo: nil } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "size cannot be less than 3"]
          end
        end

        describe "with blank input" do
          let(:input) { { foo: "" } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "size cannot be less than 3"]
          end
        end

        describe "with invalid input" do
          let(:input) { { foo: { a: 1, b: 2 } } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end
      end

      describe "with maybe" do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).maybe(min_size?: 3)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { foo: [1, 2, 3] } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with missing input" do
          let(:input) { {} }

          it "is not successful" do
            expect_not_successful result, ["is missing", "size cannot be less than 3"]
          end
        end

        describe "with nil input" do
          let(:input) { { foo: nil } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with blank input" do
          let(:input) { { foo: "" } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end

        describe "with invalid input" do
          let(:input) { { foo: { a: 1, b: 2 } } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end
      end
    end

    describe "with optional" do
      describe "with value" do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).value(min_size?: 3)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { foo: [1, 2, 3] } }

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
          let(:input) { { foo: nil } }

          it "is raises error" do
            expect { result }.to raise_error(NoMethodError)
          end
        end

        describe "with blank input" do
          let(:input) { { foo: "" } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end

        describe "with invalid input" do
          let(:input) { { foo: { a: 1, b: 2 } } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end
      end

      describe "with filled" do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).filled(min_size?: 3)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { foo: [1, 2, 3] } }

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
          let(:input) { { foo: nil } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "size cannot be less than 3"]
          end
        end

        describe "with blank input" do
          let(:input) { { foo: "" } }

          it "is not successful" do
            expect_not_successful result, ["must be filled", "size cannot be less than 3"]
          end
        end

        describe "with invalid input" do
          let(:input) { { foo: { a: 1, b: 2 } } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end
      end

      describe "with maybe" do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).maybe(min_size?: 3)
            end
          end
        end

        describe "with valid input" do
          let(:input) { { foo: [1, 2, 3] } }

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
          let(:input) { { foo: nil } }

          it "is successful" do
            expect_successful result
          end
        end

        describe "with blank input" do
          let(:input) { { foo: "" } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end

        describe "with invalid input" do
          let(:input) { { foo: { a: 1, b: 2 } } }

          it "is not successful" do
            expect_not_successful result, ["size cannot be less than 3"]
          end
        end
      end
    end
  end
end
