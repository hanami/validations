require 'test_helper'

describe 'Predicates: Exclusion' do
  include TestUtils

  describe 'with required' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          required(:foo) { exclusion?([1, 3, 5]) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 2 } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        refute_successful result, ['is missing', 'must not be one of: 1, 3, 5']
      end
    end

    describe 'with nil input' do
      let(:input) { { foo: nil } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with blank input' do
      let(:input) { { foo: '' } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with invalid type' do
      let(:input) { { foo: { a: 1 } } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 5 } }

      it 'is not successful' do
        refute_successful result, ['must not be one of: 1, 3, 5']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          optional(:foo) { exclusion?([1, 3, 5]) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 2 } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with nil input' do
      let(:input) { { foo: nil } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with blank input' do
      let(:input) { { foo: '' } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with invalid type' do
      let(:input) { { foo: { a: 1 } } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 5 } }

      it 'is not successful' do
        refute_successful result, ['must not be one of: 1, 3, 5']
      end
    end
  end

  describe 'as macro' do
    describe 'with required' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).value(exclusion?: [1, 3, 5])
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            refute_successful result, ['must not be one of: 1, 3, 5']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).filled(exclusion?: [1, 3, 5])
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            refute_successful result, ['must not be one of: 1, 3, 5']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).maybe(exclusion?: [1, 3, 5])
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            refute_successful result, ['must not be one of: 1, 3, 5']
          end
        end
      end
    end

    describe 'with optional' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).value(exclusion?: [1, 3, 5])
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            refute_successful result, ['must not be one of: 1, 3, 5']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).filled(exclusion?: [1, 3, 5])
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            refute_successful result, ['must not be one of: 1, 3, 5']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).maybe(exclusion?: [1, 3, 5])
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            refute_successful result, ['must not be one of: 1, 3, 5']
          end
        end
      end
    end
  end
end
