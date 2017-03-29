RSpec.describe 'Predicates: None' do
  include_context 'validator result'

  describe 'with required' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          required(:foo) { none? }
        end
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        refute_successful result, ['is missing']
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

      it 'is not successful' do
        refute_successful result, ['cannot be defined']
      end
    end

    describe 'with other input' do
      let(:input) { { foo: 23 } }

      it 'is not successful' do
        refute_successful result, ['cannot be defined']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          optional(:foo) { none? }
        end
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

      it 'is not successful' do
        refute_successful result, ['cannot be defined']
      end
    end

    describe 'with other input' do
      let(:input) { { foo: 23 } }

      it 'is not successful' do
        refute_successful result, ['cannot be defined']
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
              required(:foo).value(:none?)
            end
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing']
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

          it 'is not successful' do
            refute_successful result, ['cannot be defined']
          end
        end

        describe 'with other input' do
          let(:input) { { foo: 23 } }

          it 'is not successful' do
            refute_successful result, ['cannot be defined']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).filled(:none?)
            end
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is not successful' do
            refute_successful result, ['must be filled']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled']
          end
        end

        describe 'with other input' do
          let(:input) { { foo: 23 } }

          it 'is not successful' do
            refute_successful result, ['cannot be defined']
          end
        end
      end

      describe 'with maybe' do
        # it doesn't make sense to ask for a maybe key and at the same time assert it's none
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
            include Hanami::Validations

            validations do
              optional(:foo).value(:none?)
            end
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

          it 'is not successful' do
            refute_successful result, ['cannot be defined']
          end
        end

        describe 'with other input' do
          let(:input) { { foo: 23 } }

          it 'is not successful' do
            refute_successful result, ['cannot be defined']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).filled(:none?)
            end
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
            refute_successful result, ['must be filled']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled']
          end
        end

        describe 'with other input' do
          let(:input) { { foo: 23 } }

          it 'is not successful' do
            refute_successful result, ['cannot be defined']
          end
        end
      end

      describe 'with maybe' do
        # it doesn't make sense to ask for a maybe key and at the same time assert it's none
        #
        # Example:
        #
        #   validations do
        #     optional(:foo).maybe(:none?)
        #   end
      end
    end
  end
end
