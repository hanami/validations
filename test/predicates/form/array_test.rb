require 'test_helper'

describe 'Predicates: Array' do
  describe 'as macro' do
    describe 'with key' do
      before do
        @validator = Class.new do
          include Hanami::Validations
          include Hanami::Validations::Form

          key(:foo).each(:int?)
        end
      end

      describe 'with valid input' do
        let(:input) { { foo: ['3'] } }

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
          result.output.fetch(:foo).must_equal [3]
        end
      end

      describe 'with invalid input (integer as string)' do
        let(:input) { { foo: '4' } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error messages' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal(['must be an array'])
        end

        it 'does not coerce input' do
          result = @validator.new(input).validate
          result.output.fetch(:foo).must_equal '4'
        end
      end

      describe 'with invalid input (array of strings)' do
        let(:input) { { foo: ['bar'] } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error messages' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal(0 => ['must be an integer'])
        end

        it 'does not coerce input' do
          result = @validator.new(input).validate
          result.output.fetch(:foo).must_equal ['bar']
        end
      end

      describe 'with invalid input (hash)' do
        let(:input) { { foo: { 'bar' => 'baz' } } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error messages' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal(['must be an array'])
        end

        it 'does not coerce input' do
          result = @validator.new(input).validate
          result.output.fetch(:foo).must_equal('bar' => 'baz')
        end
      end
    end

    describe 'with optional' do
      before do
        @validator = Class.new do
          include Hanami::Validations
          include Hanami::Validations::Form

          optional(:foo).each(:int?)
        end
      end

      describe 'with valid input' do
        let(:input) { { foo: ['3'] } }

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
          result.output.fetch(:foo).must_equal [3]
        end
      end

      describe 'with invalid input (integer as string)' do
        let(:input) { { foo: '4' } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error messages' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal(['must be an array'])
        end

        it 'does not coerce input' do
          result = @validator.new(input).validate
          result.output.fetch(:foo).must_equal '4'
        end
      end

      describe 'with invalid input (array of strings)' do
        let(:input) { { foo: ['bar'] } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error messages' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal(0 => ['must be an integer'])
        end

        it 'does not coerce input' do
          result = @validator.new(input).validate
          result.output.fetch(:foo).must_equal ['bar']
        end
      end

      describe 'with invalid input (hash)' do
        let(:input) { { foo: { 'bar' => 'baz' } } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error messages' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal(['must be an array'])
        end

        it 'does not coerce input' do
          result = @validator.new(input).validate
          result.output.fetch(:foo).must_equal('bar' => 'baz')
        end
      end
    end
  end
end
