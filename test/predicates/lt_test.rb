require 'test_helper'

describe 'Predicates: Lt' do
  describe 'with key' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        key(:foo) { lt?(23) }
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 1 } }

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
        result.messages.fetch(:foo).must_equal ['is missing', 'must be less than 23 ( was given)']
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

      it 'is raises error' do
        exception = -> { @validator.new(input).validate }.must_raise(ArgumentError)
        exception.message.must_equal 'comparison of String with 23 failed'
      end
    end

    describe 'with invalid input type' do
      let(:input) { { foo: [] } }

      it 'is raises error' do
        -> { @validator.new(input).validate }.must_raise(NoMethodError)
      end
    end

    describe 'with equal input' do
      let(:input) { { foo: 23 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      # FIXME: open a dry-v ticket
      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be less than 23 (23 was given)', 'must be less than 23 ( was given)']
      end
    end

    describe 'with greater than input' do
      let(:input) { { foo: 99 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be less than 23 (99 was given)', 'must be less than 23 ( was given)']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        optional(:foo) { lt?(23) }
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 1 } }

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

      it 'is raises error' do
        exception = -> { @validator.new(input).validate }.must_raise(ArgumentError)
        exception.message.must_equal 'comparison of String with 23 failed'
      end
    end

    describe 'with invalid input type' do
      let(:input) { { foo: [] } }

      it 'is raises error' do
        -> { @validator.new(input).validate }.must_raise(NoMethodError)
      end
    end

    describe 'with equal input' do
      let(:input) { { foo: 23 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      # FIXME: open a dry-v ticket
      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be less than 23 (23 was given)', 'must be less than 23 ( was given)']
      end
    end

    describe 'with greater than input' do
      let(:input) { { foo: 99 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be less than 23 (99 was given)', 'must be less than 23 ( was given)']
      end
    end
  end

  describe 'with attr' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        attr(:foo) { lt?(23) }
      end
    end

    describe 'with valid input' do
      let(:input) { Input.new(1) }

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
        result.messages.fetch(:foo).must_equal ['is missing', 'must be less than 23 ( was given)']
      end
    end

    describe 'with nil input' do
      let(:input) { Input.new(nil) }

      it 'is raises error' do
        -> { @validator.new(input).validate }.must_raise(NoMethodError)
      end
    end

    describe 'with blank input' do
      let(:input) { Input.new('') }

      it 'is raises error' do
        exception = -> { @validator.new(input).validate }.must_raise(ArgumentError)
        exception.message.must_equal 'comparison of String with 23 failed'
      end
    end

    describe 'with invalid input type' do
      let(:input) { Input.new([]) }

      it 'is raises error' do
        -> { @validator.new(input).validate }.must_raise(NoMethodError)
      end
    end

    describe 'with equal input' do
      let(:input) { Input.new(23) }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      # FIXME: open a dry-v ticket
      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be less than 23 (23 was given)', 'must be less than 23 ( was given)']
      end
    end

    describe 'with greater than input' do
      let(:input) { Input.new(99) }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['must be less than 23 (99 was given)', 'must be less than 23 ( was given)']
      end
    end
  end

  describe 'as macro' do
    describe 'with required' do
      before do
        @validator = Class.new do
          include Hanami::Validations

          key(:foo).required(lt?: 23)
        end
      end

      describe 'with valid input' do
        let(:input) { { foo: 1 } }

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
          result.messages.fetch(:foo).must_equal ['is missing', 'must be less than 23 ( was given)']
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
          result.messages.fetch(:foo).must_equal ['must be filled', 'must be less than 23 ( was given)']
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
          result.messages.fetch(:foo).must_equal ['must be filled', 'must be less than 23 ( was given)']
        end
      end

      describe 'with invalid input type' do
        let(:input) { { foo: [] } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['must be filled', 'must be less than 23 ( was given)']
        end
      end

      describe 'with equal input' do
        let(:input) { { foo: 23 } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        # FIXME: open a dry-v ticket
        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['must be less than 23 (23 was given)', 'must be less than 23 ( was given)']
        end
      end

      describe 'with greater than input' do
        let(:input) { { foo: 99 } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['must be less than 23 (99 was given)', 'must be less than 23 ( was given)']
        end
      end
    end

    describe 'with maybe' do
      before do
        @validator = Class.new do
          include Hanami::Validations

          key(:foo).maybe(lt?: 23)
        end
      end

      describe 'with valid input' do
        let(:input) { { foo: 1 } }

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
          result.messages.fetch(:foo).must_equal ['is missing', 'must be less than 23 ( was given)']
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

        it 'is raises error' do
          exception = -> { @validator.new(input).validate }.must_raise(ArgumentError)
          exception.message.must_equal 'comparison of String with 23 failed'
        end
      end

      describe 'with invalid input type' do
        let(:input) { { foo: [] } }

        it 'is raises error' do
          -> { @validator.new(input).validate }.must_raise(NoMethodError)
        end
      end

      describe 'with equal input' do
        let(:input) { { foo: 23 } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        # FIXME: open a dry-v ticket
        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['must be less than 23 (23 was given)', 'must be less than 23 ( was given)']
        end
      end

      describe 'with greater than input' do
        let(:input) { { foo: 99 } }

        it 'is not successful' do
          result = @validator.new(input).validate
          result.wont_be :success?
        end

        it 'returns error message' do
          result = @validator.new(input).validate
          result.messages.fetch(:foo).must_equal ['must be less than 23 (99 was given)', 'must be less than 23 ( was given)']
        end
      end
    end
  end
end
