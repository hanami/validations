require 'test_helper'

describe 'Predicates: None' do
  describe 'with key' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        key(:foo) { none? }
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

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end

      it 'returns output value' do
        result = @validator.new(input).validate
        result.output.fetch(:foo).must_be_nil
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
        result.messages.fetch(:foo).must_equal ['cannot be defined']
      end
    end

    describe 'with other input' do
      let(:input) { { foo: 23 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['cannot be defined']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        optional(:foo) { none? }
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

      it 'returns output value' do
        result = @validator.new(input).validate
        result.output.fetch(:foo).must_be_nil
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
        result.messages.fetch(:foo).must_equal ['cannot be defined']
      end
    end

    describe 'with other input' do
      let(:input) { { foo: 23 } }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['cannot be defined']
      end
    end
  end

  describe 'with attr' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        attr(:foo) { none? }
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
        result.messages.fetch(:foo).must_equal ['is missing']
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

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['cannot be defined']
      end
    end

    describe 'with other input' do
      let(:input) { Input.new(23) }

      it 'is not successful' do
        result = @validator.new(input).validate
        result.wont_be :success?
      end

      it 'returns error message' do
        result = @validator.new(input).validate
        result.messages.fetch(:foo).must_equal ['cannot be defined']
      end
    end
  end

  describe 'as macro' do
    describe 'with key' do
      describe 'with required' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            key(:foo).required(:none?)
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

          it 'returns output value' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_be_nil
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
            result.messages.fetch(:foo).must_equal ['must be filled']
          end
        end

        describe 'with other input' do
          let(:input) { { foo: 23 } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['cannot be defined']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            key(:foo).maybe(:none?)
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

          it 'is successful' do
            result = @validator.new(input).validate
            result.must_be :success?
          end

          it 'returns output value' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_be_nil
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
            result.messages.fetch(:foo).must_equal ['cannot be defined']
          end
        end

        describe 'with other input' do
          let(:input) { { foo: 23 } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['cannot be defined']
          end
        end
      end
    end

    describe 'with optional' do
      describe 'with required' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            optional(:foo).required(:none?)
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

          it 'returns output value' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_be_nil
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
            result.messages.fetch(:foo).must_equal ['must be filled']
          end
        end

        describe 'with other input' do
          let(:input) { { foo: 23 } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['cannot be defined']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            optional(:foo).maybe(:none?)
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

          it 'returns output value' do
            result = @validator.new(input).validate
            result.output.fetch(:foo).must_be_nil
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
            result.messages.fetch(:foo).must_equal ['cannot be defined']
          end
        end

        describe 'with other input' do
          let(:input) { { foo: 23 } }

          it 'is not successful' do
            result = @validator.new(input).validate
            result.wont_be :success?
          end

          it 'returns error message' do
            result = @validator.new(input).validate
            result.messages.fetch(:foo).must_equal ['cannot be defined']
          end
        end
      end
    end
  end
end
