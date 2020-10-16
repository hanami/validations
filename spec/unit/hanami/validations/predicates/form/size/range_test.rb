# frozen_string_literal: true

require "test_helper"

describe "Predicates: Size" do
  include TestUtils

  describe "Range" do
    describe "with required" do
      before do
        @validator = Class.new do
          include Hanami::Validations::Form

          validations do
            required(:foo) { size?(2..3) }
          end
        end
      end

      describe "with valid input" do
        let(:input) { {"foo" => %w[1 2 3]} }

        it "is successful" do
          expect_successful result
        end
      end

      describe "with missing input" do
        let(:input) { {} }

        it "is not successful" do
          expect_not_successful result, ["is missing", "size must be within 2 - 3"]
        end
      end

      describe "with nil input" do
        let(:input) { {"foo" => nil} }

        it "is raises error" do
          -> { result }.must_raise(NoMethodError)
        end
      end

      describe "with blank input" do
        let(:input) { {"foo" => ""} }

        it "is not successful" do
          expect_not_successful result, ["length must be within 2 - 3"]
        end
      end

      describe "with invalid input" do
        let(:input) { {"foo" => {"a" => "1", "b" => "2", "c" => "3", "d" => "4"}} }

        it "is not successful" do
          expect_not_successful result, ["size must be within 2 - 3"]
        end
      end
    end

    describe "with optional" do
      before do
        @validator = Class.new do
          include Hanami::Validations::Form

          validations do
            optional(:foo) { size?(2..3) }
          end
        end
      end

      describe "with valid input" do
        let(:input) { {"foo" => %w[1 2 3]} }

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
        let(:input) { {"foo" => nil} }

        it "is raises error" do
          -> { result }.must_raise(NoMethodError)
        end
      end

      describe "with blank input" do
        let(:input) { {"foo" => ""} }

        it "is not successful" do
          expect_not_successful result, ["length must be within 2 - 3"]
        end
      end

      describe "with invalid input" do
        let(:input) { {"foo" => {"a" => "1", "b" => "2", "c" => "3", "d" => "4"}} }

        it "is not successful" do
          expect_not_successful result, ["size must be within 2 - 3"]
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
                required(:foo).value(size?: 2..3)
              end
            end
          end

          describe "with valid input" do
            let(:input) { {"foo" => %w[1 2 3]} }

            it "is successful" do
              expect_successful result
            end
          end

          describe "with missing input" do
            let(:input) { {} }

            it "is not successful" do
              expect_not_successful result, ["is missing", "size must be within 2 - 3"]
            end
          end

          describe "with nil input" do
            let(:input) { {"foo" => nil} }

            it "is raises error" do
              -> { result }.must_raise(NoMethodError)
            end
          end

          describe "with blank input" do
            let(:input) { {"foo" => ""} }

            it "is not successful" do
              expect_not_successful result, ["length must be within 2 - 3"]
            end
          end

          describe "with invalid input" do
            let(:input) { {"foo" => {"a" => "1", "b" => "2", "c" => "3", "d" => "4"}} }

            it "is not successful" do
              expect_not_successful result, ["size must be within 2 - 3"]
            end
          end
        end

        describe "with filled" do
          before do
            @validator = Class.new do
              include Hanami::Validations::Form

              validations do
                required(:foo).filled(size?: 2..3)
              end
            end
          end

          describe "with valid input" do
            let(:input) { {"foo" => %w[1 2 3]} }

            it "is successful" do
              expect_successful result
            end
          end

          describe "with missing input" do
            let(:input) { {} }

            it "is not successful" do
              expect_not_successful result, ["is missing", "size must be within 2 - 3"]
            end
          end

          describe "with nil input" do
            let(:input) { {"foo" => nil} }

            it "is not successful" do
              expect_not_successful result, ["must be filled", "size must be within 2 - 3"]
            end
          end

          describe "with blank input" do
            let(:input) { {"foo" => ""} }

            it "is not successful" do
              expect_not_successful result, ["must be filled", "length must be within 2 - 3"]
            end
          end

          describe "with invalid input" do
            let(:input) { {"foo" => {"a" => "1", "b" => "2", "c" => "3", "d" => "4"}} }

            it "is not successful" do
              expect_not_successful result, ["size must be within 2 - 3"]
            end
          end
        end

        describe "with maybe" do
          before do
            @validator = Class.new do
              include Hanami::Validations::Form

              validations do
                required(:foo).maybe(size?: 2..3)
              end
            end
          end

          describe "with valid input" do
            let(:input) { {"foo" => %w[1 2 3]} }

            it "is successful" do
              expect_successful result
            end
          end

          describe "with missing input" do
            let(:input) { {} }

            it "is not successful" do
              expect_not_successful result, ["is missing", "size must be within 2 - 3"]
            end
          end

          describe "with nil input" do
            let(:input) { {"foo" => nil} }

            it "is successful" do
              expect_successful result
            end
          end

          describe "with blank input" do
            let(:input) { {"foo" => ""} }

            it "is successful" do
              expect_successful result
            end
          end

          describe "with invalid input" do
            let(:input) { {"foo" => {"a" => "1", "b" => "2", "c" => "3", "d" => "4"}} }

            it "is not successful" do
              expect_not_successful result, ["size must be within 2 - 3"]
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
                optional(:foo).value(size?: 2..3)
              end
            end
          end

          describe "with valid input" do
            let(:input) { {"foo" => %w[1 2 3]} }

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
            let(:input) { {"foo" => nil} }

            it "is raises error" do
              -> { result }.must_raise(NoMethodError)
            end
          end

          describe "with blank input" do
            let(:input) { {"foo" => ""} }

            it "is not successful" do
              expect_not_successful result, ["length must be within 2 - 3"]
            end
          end

          describe "with invalid input" do
            let(:input) { {"foo" => {"a" => "1", "b" => "2", "c" => "3", "d" => "4"}} }

            it "is not successful" do
              expect_not_successful result, ["size must be within 2 - 3"]
            end
          end
        end

        describe "with filled" do
          before do
            @validator = Class.new do
              include Hanami::Validations::Form

              validations do
                optional(:foo).filled(size?: 2..3)
              end
            end
          end

          describe "with valid input" do
            let(:input) { {"foo" => %w[1 2 3]} }

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
            let(:input) { {"foo" => nil} }

            it "is not successful" do
              expect_not_successful result, ["must be filled", "size must be within 2 - 3"]
            end
          end

          describe "with blank input" do
            let(:input) { {"foo" => ""} }

            it "is not successful" do
              expect_not_successful result, ["must be filled", "length must be within 2 - 3"]
            end
          end

          describe "with invalid input" do
            let(:input) { {"foo" => {"a" => "1", "b" => "2", "c" => "3", "d" => "4"}} }

            it "is not successful" do
              expect_not_successful result, ["size must be within 2 - 3"]
            end
          end
        end

        describe "with maybe" do
          before do
            @validator = Class.new do
              include Hanami::Validations::Form

              validations do
                optional(:foo).maybe(size?: 2..3)
              end
            end
          end

          describe "with valid input" do
            let(:input) { {"foo" => %w[1 2 3]} }

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
            let(:input) { {"foo" => nil} }

            it "is successful" do
              expect_successful result
            end
          end

          describe "with blank input" do
            let(:input) { {"foo" => ""} }

            it "is successful" do
              expect_successful result
            end
          end

          describe "with invalid input" do
            let(:input) { {"foo" => {"a" => "1", "b" => "2", "c" => "3", "d" => "4"}} }

            it "is not successful" do
              expect_not_successful result, ["size must be within 2 - 3"]
            end
          end
        end
      end
    end
  end
end
