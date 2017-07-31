RSpec.describe 'Predicates: Filled' do
  include_context 'validator result'

  describe 'with key' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          required(:foo) { filled? }
        end
      end
    end

    describe 'with valid input (array)' do
      let(:input) { { foo: [23] } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with valid input (hash)' do
      let(:input) { { foo: { bar: 23 } } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        expect_not_successful result, ['is missing']
      end
    end

    describe 'with nil input' do
      let(:input) { { foo: nil } }

      it 'is not successful' do
        expect_not_successful result, ['must be filled']
      end
    end

    describe 'with blank input' do
      let(:input) { { foo: '' } }

      it 'is not successful' do
        expect_not_successful result, ['must be filled']
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: [] } }

      it 'is not successful' do
        expect_not_successful result, ['must be filled']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          optional(:foo) { filled? }
        end
      end
    end

    describe 'with valid input (array)' do
      let(:input) { { foo: [23] } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with valid input (hash)' do
      let(:input) { { foo: { bar: 23 } } }

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
      let(:input) { { foo: nil } }

      it 'is not successful' do
        expect_not_successful result, ['must be filled']
      end
    end

    describe 'with blank input' do
      let(:input) { { foo: '' } }

      it 'is not successful' do
        expect_not_successful result, ['must be filled']
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: [] } }

      it 'is not successful' do
        expect_not_successful result, ['must be filled']
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
              required(:foo).value(:filled?)
            end
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { foo: [23] } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { foo: { bar: 23 } } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).filled
            end
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { foo: [23] } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { foo: { bar: 23 } } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).maybe(:filled?)
            end
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { foo: [23] } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { foo: { bar: 23 } } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
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
              optional(:foo).value(:filled?)
            end
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { foo: [23] } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { foo: { bar: 23 } } }

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
          let(:input) { { foo: nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).filled
            end
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { foo: [23] } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { foo: { bar: 23 } } }

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
          let(:input) { { foo: nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).maybe(:filled?)
            end
          end
        end

        describe 'with valid input (array)' do
          let(:input) { { foo: [23] } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with valid input (hash)' do
          let(:input) { { foo: { bar: 23 } } }

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
          let(:input) { { foo: nil } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end

        describe 'with invalid input' do
          let(:input) { { foo: [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled']
          end
        end
      end
    end
  end
end
