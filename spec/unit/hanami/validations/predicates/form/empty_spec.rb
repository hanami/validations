# frozen_string_literal: true
RSpec.describe 'Predicates: Empty' do
  include_context 'validator result'

  describe 'with required' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          required(:foo) { empty? }
        end
      end
    end

    describe 'with valid input (array)' do
      let(:input) { { 'foo' => [] } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with valid input (hash)' do
      let(:input) { { 'foo' => {} } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        expect_not_successful result, ['is missing', 'must be empty']
      end
    end

    describe 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with invalid input' do
      let(:input) { { 'foo' => ['23'] } }

      it 'is not successful' do
        expect_not_successful result, ['must be empty']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          optional(:foo) { empty? }
        end
      end
    end

    describe 'with valid input (array)' do
      let(:input) { { 'foo' => [] } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with valid input (hash)' do
      let(:input) { { 'foo' => {} } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with invalid input' do
      let(:input) { { 'foo' => ['23'] } }

      it 'is not successful' do
        expect_not_successful result, ['must be empty']
      end
    end
  end

  describe 'as macro' do
    describe 'with required' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).value(:empty?)
            end
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { 'foo' => [] } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { 'foo' => {} } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing', 'must be empty']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => ['23'] } }

          it 'is not successful' do
            expect_not_successful result, ['must be empty']
          end
        end
      end

      describe 'with filled' do
        # it doesn't make sense to ask for a filled key and at the same time assert it's empty
        #
        # Example:
        #
        #   validations do
        #     required(:foo).filled(:empty?)
        #   end
      end

      describe 'with maybe' do
        # it doesn't make sense to ask for a maybe key and at the same time assert it's empty
        #
        # Example:
        #
        #   validations do
        #     required(:foo).maybe(:empty?)
        #   end
      end
    end

    describe 'with optional' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).value(:empty?)
            end
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { 'foo' => [] } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { 'foo' => {} } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => ['23'] } }

          it 'is not successful' do
            expect_not_successful result, ['must be empty']
          end
        end
      end

      describe 'with filled' do
        # it doesn't make sense to ask for a filled key and at the same time assert it's empty
        #
        # Example:
        #
        #   validations do
        #     optional(:foo).filled(:empty?)
        #   end
      end

      describe 'with maybe' do
        # it doesn't make sense to ask for a filled key and at the same time assert it's empty
        #
        # Example:
        #
        #   validations do
        #     optional(:foo).maybe(:empty?)
        #   end
      end
    end
  end
end
