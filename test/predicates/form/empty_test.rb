require 'test_helper'

describe 'Predicates: Empty' do
  describe 'as macro' do
    describe 'with key' do
      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations
            include Hanami::Validations::Form

            key(:foo).maybe(:empty?)
          end
        end

        describe 'with valid input (string)' do
          let(:input) { { foo: '' } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error messages' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal nil
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { foo: [] } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error messages' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal []
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { foo: {} } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error messages' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal({})
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
            result.messages.fetch(:foo).must_equal ['is missing', 'must be empty']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error messages' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal nil
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: ['23'] } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['must be empty']
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal ['23']
          end
        end
      end
    end

    describe 'with optional' do
      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations
            include Hanami::Validations::Form

            optional(:foo).maybe(:empty?)
          end
        end

        describe 'with valid input (empty string)' do
          let(:input) { { foo: '' } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error messages' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal nil
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { foo: [] } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error messages' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal []
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { foo: {} } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error messages' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal({})
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'does not coerces input' do
            result = @validator.new(input).validate
            result.output.key?(:foo).must_equal false
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'has not error messages' do
            result = @validator.new(input).validate
            result.messages[:foo].must_be_nil
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal nil
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: ['23'] } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['must be empty']
          end

          it 'coerces input' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_equal ['23']
          end
        end
      end
    end
  end
end
