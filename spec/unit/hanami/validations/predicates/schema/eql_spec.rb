RSpec.describe 'Predicates: Eql' do
  include_context 'validator result'

  describe 'with required' do
    let(:validator_class) do
      Class.new(Hanami::Validations) do
        validations do
          required(:foo) { eql?(23) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 23 } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        expect_not_successful result, ['is missing', 'must be equal to 23']
      end
    end

    describe 'with nil input' do
      let(:input) { { foo: nil } }

      it 'is not successful' do
        expect_not_successful result, ['must be equal to 23']
      end
    end

    describe 'with blank input' do
      let(:input) { { foo: '' } }

      it 'is not successful' do
        expect_not_successful result, ['must be equal to 23']
      end
    end
  end

  describe 'with optional' do
    let(:validator_class) do
      Class.new(Hanami::Validations) do
        validations do
          optional(:foo) { eql?(23) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 23 } }

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
        expect_not_successful result, ['must be equal to 23']
      end
    end

    describe 'with blank input' do
      let(:input) { { foo: '' } }

      it 'is not successful' do
        expect_not_successful result, ['must be equal to 23']
      end
    end
  end

  describe 'as macro' do
    describe 'with required' do
      describe 'with value' do
        let(:validator_class) do
          Class.new(Hanami::Validations) do
            validations do
              required(:foo).value(eql?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing', 'must be equal to 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be equal to 23']
          end
        end
      end

      describe 'with filled' do
        let(:validator_class) do
          Class.new(Hanami::Validations) do
            validations do
              required(:foo).filled(eql?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing', 'must be equal to 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be equal to 23']
          end
        end
      end

      describe 'with maybe' do
        let(:validator_class) do
          Class.new(Hanami::Validations) do
            validations do
              required(:foo).maybe(eql?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing', 'must be equal to 23']
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
            expect_not_successful result, ['must be equal to 23']
          end
        end
      end
    end

    describe 'with optional' do
      describe 'with value' do
        let(:validator_class) do
          Class.new(Hanami::Validations) do
            validations do
              optional(:foo).value(eql?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 23 } }

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
            expect_not_successful result, ['must be equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be equal to 23']
          end
        end
      end

      describe 'with filled' do
        let(:validator_class) do
          Class.new(Hanami::Validations) do
            validations do
              optional(:foo).filled(eql?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 23 } }

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
            expect_not_successful result, ['must be filled', 'must be equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be equal to 23']
          end
        end
      end

      describe 'with maybe' do
        let(:validator_class) do
          Class.new(Hanami::Validations) do
            validations do
              optional(:foo).maybe(eql?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 23 } }

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
            expect_not_successful result, ['must be equal to 23']
          end
        end
      end
    end
  end
end
