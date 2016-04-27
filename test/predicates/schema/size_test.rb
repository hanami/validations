require 'test_helper'

describe 'Predicates: Size' do
  describe 'Fixed (integer)' do
    describe 'with key' do
      before do
        @validator = Class.new do
          include Hanami::Validations

          validations do
            key(:foo) { size?(3) }
          end
        end
      end

      describe 'with valid input' do
        let(:input) { { foo: [1, 2, 3] } }

        it 'is successful' do
          result = @validator.new(input).validate
          result.must_be :success?
        end

        it 'has not error messages' do
          result = @validator.new(input).validate
          result.messages[:foo].must_be_nil
        end
      end

      describe 'with missing input' do
        let(:input) { {} }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['is missing', 'size must be 3']
        end
      end

      describe 'with nil input' do
        let(:input) { { foo: nil } }

        it 'is raises error' do
          -> { @validator.new(input).validate }.must_raise(NoMethodError)
        end
      end

      describe 'with blank input' do
        let(:input) { { foo: '' } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        # FIXME: open dry-v ticket: double validation message
        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['length must be 3', 'size must be 3']
        end
      end

      describe 'with invalid input' do
        let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['size must be 3']
        end
      end
    end

    describe 'with optional' do
      before do
        @validator = Class.new do
          include Hanami::Validations

          validations do
            optional(:foo) { size?(3) }
          end
        end
      end

      describe 'with valid input' do
        let(:input) { { foo: [1, 2, 3] } }

        it 'is successful' do
          result = @validator.new(input).validate
          result.must_be :success?
        end

        it 'has not error messages' do
          result = @validator.new(input).validate
          result.messages[:foo].must_be_nil
        end
      end

      describe 'with missing input' do
        let(:input) { {} }

        it 'is successful' do
          result = @validator.new(input).validate
          result.must_be :success?
        end

        it 'has not error messages' do
          result = @validator.new(input).validate
          result.messages[:foo].must_be_nil
        end
      end

      describe 'with nil input' do
        let(:input) { { foo: nil } }

        it 'is raises error' do
          -> { @validator.new(input).validate }.must_raise(NoMethodError)
        end
      end

      describe 'with blank input' do
        let(:input) { { foo: '' } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        # FIXME: open dry-v ticket: double validation message
        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['length must be 3', 'size must be 3']
        end
      end

      describe 'with invalid input' do
        let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['size must be 3']
        end
      end
    end

    describe 'as macro' do
      describe 'with key' do
        describe 'with required' do
          before do
            @validator = Class.new do
              include Hanami::Validations

              validations do
                key(:foo).required(size?: 3)
              end
            end
          end

          describe 'with valid input' do
            let(:input) { { foo: [1, 2, 3] } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error messages' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with missing input' do
            let(:input) { {} }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['is missing', 'size must be 3']
            end
          end

          describe 'with nil input' do
            let(:input) { { foo: nil } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['must be filled', 'size must be 3']
            end
          end

          describe 'with blank input' do
            let(:input) { { foo: '' } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            # FIXME: open dry-v ticket: double validation message
            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['must be filled', 'size must be 3']
            end
          end

          describe 'with invalid input' do
            let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['size must be 3']
            end
          end
        end

        describe 'with maybe' do
          before do
            @validator = Class.new do
              include Hanami::Validations

              validations do
                key(:foo).maybe(size?: 3)
              end
            end
          end

          describe 'with valid input' do
            let(:input) { { foo: [1, 2, 3] } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error messages' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with missing input' do
            let(:input) { {} }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['is missing', 'size must be 3']
            end
          end

          describe 'with nil input' do
            let(:input) { { foo: nil } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error message' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with blank input' do
            let(:input) { { foo: '' } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            # FIXME: open dry-v ticket: double validation message
            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['length must be 3', 'size must be 3']
            end
          end

          describe 'with invalid input' do
            let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['size must be 3']
            end
          end
        end
      end

      describe 'with optional' do
        describe 'with required' do
          before do
            @validator = Class.new do
              include Hanami::Validations

              validations do
                optional(:foo).required(size?: 3)
              end
            end
          end

          describe 'with valid input' do
            let(:input) { { foo: [1, 2, 3] } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error messages' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with missing input' do
            let(:input) { {} }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error message' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with nil input' do
            let(:input) { { foo: nil } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['must be filled', 'size must be 3']
            end
          end

          describe 'with blank input' do
            let(:input) { { foo: '' } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            # FIXME: open dry-v ticket: double validation message
            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['must be filled', 'size must be 3']
            end
          end

          describe 'with invalid input' do
            let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['size must be 3']
            end
          end
        end

        describe 'with maybe' do
          before do
            @validator = Class.new do
              include Hanami::Validations

              validations do
                optional(:foo).maybe(size?: 3)
              end
            end
          end

          describe 'with valid input' do
            let(:input) { { foo: [1, 2, 3] } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error messages' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with missing input' do
            let(:input) { {} }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error message' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with nil input' do
            let(:input) { { foo: nil } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error message' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with blank input' do
            let(:input) { { foo: '' } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            # FIXME: open dry-v ticket: double validation message
            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['length must be 3', 'size must be 3']
            end
          end

          describe 'with invalid input' do
            let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['size must be 3']
            end
          end
        end
      end
    end
  end

  describe 'Range' do
    describe 'with key' do
      before do
        @validator = Class.new do
          include Hanami::Validations

          validations do
            key(:foo) { size?(2..3) }
          end
        end
      end

      describe 'with valid input' do
        let(:input) { { foo: [1, 2, 3] } }

        it 'is successful' do
          result = @validator.new(input).validate
          result.must_be :success?
        end

        it 'has not error messages' do
          result = @validator.new(input).validate
          result.messages[:foo].must_be_nil
        end
      end

      describe 'with missing input' do
        let(:input) { {} }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['is missing', 'size must be within 2 - 3']
        end
      end

      describe 'with nil input' do
        let(:input) { { foo: nil } }

        it 'is raises error' do
          -> { @validator.new(input).validate }.must_raise(NoMethodError)
        end
      end

      describe 'with blank input' do
        let(:input) { { foo: '' } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        # FIXME: open dry-v ticket: double validation message
        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['length must be within 2 - 3', 'size must be within 2 - 3']
        end
      end

      describe 'with invalid input' do
        let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['size must be within 2 - 3']
        end
      end
    end

    describe 'with optional' do
      before do
        @validator = Class.new do
          include Hanami::Validations

          validations do
            optional(:foo) { size?(2..3) }
          end
        end
      end

      describe 'with valid input' do
        let(:input) { { foo: [1, 2, 3] } }

        it 'is successful' do
          result = @validator.new(input).validate
          result.must_be :success?
        end

        it 'has not error messages' do
          result = @validator.new(input).validate
          result.messages[:foo].must_be_nil
        end
      end

      describe 'with missing input' do
        let(:input) { {} }

        it 'is successful' do
          result = @validator.new(input).validate
          result.must_be :success?
        end

        it 'has not error messages' do
          result = @validator.new(input).validate
          result.messages[:foo].must_be_nil
        end
      end

      describe 'with nil input' do
        let(:input) { { foo: nil } }

        it 'is raises error' do
          -> { @validator.new(input).validate }.must_raise(NoMethodError)
        end
      end

      describe 'with blank input' do
        let(:input) { { foo: '' } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        # FIXME: open dry-v ticket: double validation message
        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['length must be within 2 - 3', 'size must be within 2 - 3']
        end
      end

      describe 'with invalid input' do
        let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['size must be within 2 - 3']
        end
      end
    end

    describe 'as macro' do
      describe 'with key' do
        describe 'with required' do
          before do
            @validator = Class.new do
              include Hanami::Validations

              validations do
                key(:foo).required(size?: 2..3)
              end
            end
          end

          describe 'with valid input' do
            let(:input) { { foo: [1, 2, 3] } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error messages' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with missing input' do
            let(:input) { {} }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['is missing', 'size must be within 2 - 3']
            end
          end

          describe 'with nil input' do
            let(:input) { { foo: nil } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['must be filled', 'size must be within 2 - 3']
            end
          end

          describe 'with blank input' do
            let(:input) { { foo: '' } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            # FIXME: open dry-v ticket: double validation message
            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['must be filled', 'size must be within 2 - 3']
            end
          end

          describe 'with invalid input' do
            let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['size must be within 2 - 3']
            end
          end
        end

        describe 'with maybe' do
          before do
            @validator = Class.new do
              include Hanami::Validations

              validations do
                key(:foo).maybe(size?: 2..3)
              end
            end
          end

          describe 'with valid input' do
            let(:input) { { foo: [1, 2, 3] } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error messages' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with missing input' do
            let(:input) { {} }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['is missing', 'size must be within 2 - 3']
            end
          end

          describe 'with nil input' do
            let(:input) { { foo: nil } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error message' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with blank input' do
            let(:input) { { foo: '' } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            # FIXME: open dry-v ticket: double validation message
            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['length must be within 2 - 3', 'size must be within 2 - 3']
            end
          end

          describe 'with invalid input' do
            let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['size must be within 2 - 3']
            end
          end
        end
      end

      describe 'with optional' do
        describe 'with required' do
          before do
            @validator = Class.new do
              include Hanami::Validations

              validations do
                optional(:foo).required(size?: 2..3)
              end
            end
          end

          describe 'with valid input' do
            let(:input) { { foo: [1, 2, 3] } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error messages' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with missing input' do
            let(:input) { {} }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error message' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with nil input' do
            let(:input) { { foo: nil } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['must be filled', 'size must be within 2 - 3']
            end
          end

          describe 'with blank input' do
            let(:input) { { foo: '' } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            # FIXME: open dry-v ticket: double validation message
            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['must be filled', 'size must be within 2 - 3']
            end
          end

          describe 'with invalid input' do
            let(:input) { { foo: { a: 1, b: 2, c: 3, d: 4 } } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['size must be within 2 - 3']
            end
          end
        end

        describe 'with maybe' do
          before do
            @validator = Class.new do
              include Hanami::Validations

              validations do
                optional(:foo).maybe(size?: 2..3)
              end
            end
          end

          describe 'with valid input' do
            let(:input) { { foo: [1, 2, 3] } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error messages' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with missing input' do
            let(:input) { {} }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error message' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with nil input' do
            let(:input) { { foo: nil } }

            it 'is successful' do
              result = @validator.new(input).validate
              result.must_be :success?
            end

            it 'has not error message' do
              result = @validator.new(input).validate
              result.messages[:foo].must_be_nil
            end
          end

          describe 'with blank input' do
            let(:input) { { foo: '' } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            # FIXME: open dry-v ticket: double validation message
            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['length must be within 2 - 3', 'size must be within 2 - 3']
            end
          end

          describe 'with invalid input' do
            let(:input) { { foo: {a: 1, b: 2, c: 3, d: 4 } } }

            it 'is not successful' do
              result = @validator.new(input).validate
              result.wont_be :success?
            end

            it 'returns error message' do
              result = @validator.new(input).validate
              result.messages.fetch(:foo).must_equal ['size must be within 2 - 3']
            end
          end
        end
      end
    end
  end
end
