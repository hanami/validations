RSpec.describe 'Predicates: Gt' do
  include_context 'validator result'

  describe 'with required' do
    let(:validator_class) do
      Class.new(Hanami::Validations::Form) do
        validations do
          required(:foo) { int? & gt?(23) }
        end
      end
    end

    describe 'with invalid input' do
      let(:input) { { 'foo' => '33' } }

      it 'is successful' do
        expect_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        expect_not_successful result, ['is missing', 'must be greater than 23']
      end
    end

    describe 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is not successful' do
        expect_not_successful result, ['must be an integer', 'must be greater than 23']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        expect_not_successful result, ['must be an integer', 'must be greater than 23']
      end
    end

    describe 'with invalid input type' do
      let(:input) { { 'foo' => [] } }

      it 'is not successful' do
        expect_not_successful result, ['must be an integer', 'must be greater than 23']
      end
    end

    describe 'with equal input' do
      let(:input) { { 'foo' => '23' } }

      it 'is not successful' do
        expect_not_successful result, ['must be greater than 23']
      end
    end

    describe 'with less than input' do
      let(:input) { { 'foo' => '0' } }

      it 'is not successful' do
        expect_not_successful result, ['must be greater than 23']
      end
    end
  end

  describe 'with optional' do
    let(:validator_class) do
      Class.new(Hanami::Validations::Form) do
        validations do
          optional(:foo) { int? & gt?(23) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { 'foo' => '33' } }

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
      let(:input) { { 'foo' => nil } }

      it 'is not successful' do
        expect_not_successful result, ['must be an integer', 'must be greater than 23']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        expect_not_successful result, ['must be an integer', 'must be greater than 23']
      end
    end

    describe 'with invalid input type' do
      let(:input) { { 'foo' => [] } }

      it 'is not successful' do
        expect_not_successful result, ['must be an integer', 'must be greater than 23']
      end
    end

    describe 'with equal input' do
      let(:input) { { 'foo' => '23' } }

      it 'is not successful' do
        expect_not_successful result, ['must be greater than 23']
      end
    end

    describe 'with less than input' do
      let(:input) { { 'foo' => '0' } }

      it 'is not successful' do
        expect_not_successful result, ['must be greater than 23']
      end
    end
  end

  describe 'as macro' do
    describe 'with required' do
      describe 'with value' do
        let(:validator_class) do
          Class.new(Hanami::Validations::Form) do
            validations do
              required(:foo).value(:int?, gt?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '33' } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing', 'must be greater than 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be an integer', 'must be greater than 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be an integer', 'must be greater than 23']
          end
        end

        describe 'with invalid input type' do
          let(:input) { { 'foo' => [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be an integer', 'must be greater than 23']
          end
        end

        describe 'with equal input' do
          let(:input) { { 'foo' => '23' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end

        describe 'with less than input' do
          let(:input) { { 'foo' => '0' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end
      end

      describe 'with filled' do
        let(:validator_class) do
          Class.new(Hanami::Validations::Form) do
            validations do
              required(:foo).filled(:int?, gt?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '33' } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing', 'must be greater than 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be greater than 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be greater than 23']
          end
        end

        describe 'with invalid input type' do
          let(:input) { { 'foo' => [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be greater than 23']
          end
        end

        describe 'with equal input' do
          let(:input) { { 'foo' => '23' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end

        describe 'with less than input' do
          let(:input) { { 'foo' => '0' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end
      end

      describe 'with maybe' do
        let(:validator_class) do
          Class.new(Hanami::Validations::Form) do
            validations do
              required(:foo).maybe(:int?, gt?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => 33 } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect_not_successful result, ['is missing', 'must be greater than 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with invalid input type' do
          let(:input) { { 'foo' => [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be an integer', 'must be greater than 23']
          end
        end

        describe 'with equal input' do
          let(:input) { { 'foo' => '23' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end

        describe 'with less than input' do
          let(:input) { { 'foo' => '0' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end
      end
    end

    describe 'with optional' do
      describe 'with value' do
        let(:validator_class) do
          Class.new(Hanami::Validations::Form) do
            validations do
              optional(:foo).value(:int?, gt?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '33' } }

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
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be an integer', 'must be greater than 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be an integer', 'must be greater than 23']
          end
        end

        describe 'with invalid input type' do
          let(:input) { { 'foo' => [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be an integer', 'must be greater than 23']
          end
        end

        describe 'with equal input' do
          let(:input) { { 'foo' => '23' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end

        describe 'with less than input' do
          let(:input) { { 'foo' => '0' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end
      end

      describe 'with filled' do
        let(:validator_class) do
          Class.new(Hanami::Validations::Form) do
            validations do
              optional(:foo).filled(:int?, gt?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '33' } }

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
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be greater than 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be greater than 23']
          end
        end

        describe 'with invalid input type' do
          let(:input) { { 'foo' => [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be filled', 'must be greater than 23']
          end
        end

        describe 'with equal input' do
          let(:input) { { 'foo' => '23' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end

        describe 'with less than input' do
          let(:input) { { 'foo' => '0' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end
      end

      describe 'with maybe' do
        let(:validator_class) do
          Class.new(Hanami::Validations::Form) do
            validations do
              optional(:foo).maybe(:int?, gt?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '33' } }

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
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is successful' do
            expect_successful result
          end
        end

        describe 'with invalid input type' do
          let(:input) { { 'foo' => [] } }

          it 'is not successful' do
            expect_not_successful result, ['must be an integer', 'must be greater than 23']
          end
        end

        describe 'with equal input' do
          let(:input) { { 'foo' => '23' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end

        describe 'with less than input' do
          let(:input) { { 'foo' => '0' } }

          it 'is not successful' do
            expect_not_successful result, ['must be greater than 23']
          end
        end
      end
    end
  end
end
