require 'test_helper'

describe 'Predicates: Exclusion' do
  describe 'with key' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        key(:foo) { exclusion?([1, 3, 5]) }
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 2 } }

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
        result.messages.fetch(:foo).must_equal ['is missing', 'must not be one of: 1, 3, 5']
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

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'has not error message' do
        result = @validator.new(input).validate
        result.messages[:foo].must_be_nil
      end
    end

    describe 'with invalid type' do
      let(:input) { { foo: { a: 1 } } }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'has not error message' do
        result = @validator.new(input).validate
        result.messages[:foo].must_be_nil
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 5 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must not be one of: 1, 3, 5']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        optional(:foo) { exclusion?([1, 3, 5]) }
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 2 } }

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

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'has not error message' do
        result = @validator.new(input).validate
        result.messages[:foo].must_be_nil
      end
    end

    describe 'with invalid type' do
      let(:input) { { foo: { a: 1 } } }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'has not error message' do
        result = @validator.new(input).validate
        result.messages[:foo].must_be_nil
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 5 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must not be one of: 1, 3, 5']
      end
    end
  end

  describe 'with attr' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        attr(:foo) { exclusion?([1, 3, 5]) }
      end
    end

    describe 'with valid input' do
      let(:input) { Input.new(2) }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'has not error messages' do
        result = @validator.new(input).validate
        result.messages[:foo].must_be_nil
      end
    end

    describe 'with unknown method' do
      let(:input) { Object.new }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['is missing', 'must not be one of: 1, 3, 5']
      end
    end

    describe 'with nil input' do
      let(:input) { Input.new(nil) }

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
      let(:input) { Input.new('') }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'has not error message' do
        result = @validator.new(input).validate
        result.messages[:foo].must_be_nil
      end
    end

    describe 'with invalid type' do
      let(:input) { Input.new({ a: 1 }) }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'has not error message' do
        result = @validator.new(input).validate
        result.messages[:foo].must_be_nil
      end
    end

    describe 'with invalid input' do
      let(:input) { Input.new(5) }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must not be one of: 1, 3, 5']
      end
    end
  end

  describe 'as macro' do
    describe 'with key' do
      describe 'with required' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            key(:foo).required(exclusion?: [1, 3, 5])
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

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
            result.messages.fetch(:foo).must_equal ['is missing', 'must not be one of: 1, 3, 5']
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
            result.messages.fetch(:foo).must_equal ['must be filled', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['must be filled', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error message' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['must not be one of: 1, 3, 5']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            key(:foo).maybe(exclusion?: [1, 3, 5])
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

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
            result.messages.fetch(:foo).must_equal ['is missing', 'must not be one of: 1, 3, 5']
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

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error message' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error message' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['must not be one of: 1, 3, 5']
          end
        end
      end
    end

    describe 'with optional' do
      describe 'with required' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            optional(:foo).required(exclusion?: [1, 3, 5])
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

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
            result.messages.fetch(:foo).must_equal ['must be filled', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['must be filled', 'must not be one of: 1, 3, 5']
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error message' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['must not be one of: 1, 3, 5']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            optional(:foo).maybe(exclusion?: [1, 3, 5])
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 2 } }

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

          it 'has not message' do
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

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error message' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end
        end

        describe 'with invalid type' do
          let(:input) { { foo: { a: 1 } } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error message' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: 5 } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['must not be one of: 1, 3, 5']
          end
        end
      end
    end
  end
end
