require 'test_helper'

describe 'Predicates: Array' do
  describe 'with key' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        key(:foo) { array? { each { int? } } }
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: [3] } }

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
        result.messages.fetch(:foo).must_equal ['is missing']
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
        result.messages.fetch(:foo).must_equal ['must be an array']
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
        result.messages.fetch(:foo).must_equal ['must be an array']
      end
    end

    describe 'with invalid type' do
      let(:input) { { foo: { a: 1 } } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be an array']
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 4 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be an array']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        optional(:foo) { inclusion?([1, 3, 5]) }
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 3 } }

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

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be one of: 1, 3, 5']
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
        result.messages.fetch(:foo).must_equal ['must be one of: 1, 3, 5']
      end
    end

    describe 'with invalid type' do
      let(:input) { { foo: { a: 1 } } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be one of: 1, 3, 5']
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 4 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be one of: 1, 3, 5']
      end
    end
  end

  describe 'with attr' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        attr(:foo) { inclusion?([1, 3, 5]) }
      end
    end

    describe 'with valid input' do
      let(:input) { Input.new(3) }

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
        result.messages.fetch(:foo).must_equal ['is missing', 'must be one of: 1, 3, 5']
      end
    end

    describe 'with nil input' do
      let(:input) { Input.new(nil) }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be one of: 1, 3, 5']
      end
    end

    describe 'with blank input' do
      let(:input) { Input.new('') }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be one of: 1, 3, 5']
      end
    end

    describe 'with invalid type' do
      let(:input) { Input.new(a: 1) }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be one of: 1, 3, 5']
      end
    end

    describe 'with invalid input' do
      let(:input) { Input.new(4) }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be one of: 1, 3, 5']
      end
    end
  end

  describe 'as macro' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        key(:foo).each(:int?)
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: [3] } }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'has not error messages' do
        result = @validator.new(input).validate
        result.messages[:foo].must_be_nil
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: [:bar] } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error messages' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal(0 => ['must be an integer'])
      end
    end
  end
end
