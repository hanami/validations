RSpec.describe 'Predicates: Gteq' do
  include_context 'validator result'

  describe 'with required' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          required(:foo) { gteq?(23) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 33 } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        refute_successful result, ['is missing', 'must be greater than or equal to 23']
      end
    end

    describe 'with nil input' do
      let(:input) { { foo: nil } }

      it 'is raises error' do
        expect { result }.to raise_error(NoMethodError)
      end
    end

    describe 'with blank input' do
      let(:input) { { foo: '' } }

      it 'is raises error' do
        expect { result }.to raise_error(ArgumentError, 'comparison of String with 23 failed')
      end
    end

    describe 'with invalid input type' do
      let(:input) { { foo: [] } }

      it 'is raises error' do
        expect { result }.to raise_error(NoMethodError)
      end
    end

    describe 'with equal input' do
      let(:input) { { foo: 23 } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with less than input' do
      let(:input) { { foo: 0 } }

      it 'is not successful' do
        refute_successful result, ['must be greater than or equal to 23']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          optional(:foo) { gteq?(23) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 33 } }

      it 'is successful' do
        assert_successful result
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

      it 'is raises error' do
        expect { result }.to raise_error(NoMethodError)
      end
    end

    describe 'with blank input' do
      let(:input) { { foo: '' } }

      it 'is raises error' do
        expect { result }.to raise_error(ArgumentError, 'comparison of String with 23 failed')
      end
    end

    describe 'with invalid input type' do
      let(:input) { { foo: [] } }

      it 'is raises error' do
        expect { result }.to raise_error(NoMethodError)
      end
    end

    describe 'with equal input' do
      let(:input) { { foo: 23 } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with less than input' do
      let(:input) { { foo: 0 } }

      it 'is not successful' do
        refute_successful result, ['must be greater than or equal to 23']
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
              required(:foo).value(gteq?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 33 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be greater than or equal to 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is raises error' do
            expect { result }.to raise_error NoMethodError
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is raises error' do
            expect { result }.to raise_error ArgumentError, 'comparison of String with 23 failed'
          end
        end

        describe 'with invalid input type' do
          let(:input) { { foo: [] } }

          it 'is raises error' do
            expect { result }.to raise_error NoMethodError
          end
        end

        describe 'with equal input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with less than input' do
          let(:input) { { foo: 0 } }

          it 'is not successful' do
            refute_successful result, ['must be greater than or equal to 23']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).filled(gteq?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 33 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be greater than or equal to 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { foo: nil } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be greater than or equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be greater than or equal to 23']
          end
        end

        describe 'with invalid input type' do
          let(:input) { { foo: [] } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be greater than or equal to 23']
          end
        end

        describe 'with equal input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with less than input' do
          let(:input) { { foo: 0 } }

          it 'is not successful' do
            refute_successful result, ['must be greater than or equal to 23']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              required(:foo).maybe(gteq?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 33 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be greater than or equal to 23']
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

          it 'is raises error' do
            expect { result }.to raise_error(ArgumentError, 'comparison of String with 23 failed')
          end
        end

        describe 'with invalid input type' do
          let(:input) { { foo: [] } }

          it 'is raises error' do
            expect { result }.to raise_error(NoMethodError)
          end
        end

        describe 'with equal input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with less than input' do
          let(:input) { { foo: 0 } }

          it 'is not successful' do
            refute_successful result, ['must be greater than or equal to 23']
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
              optional(:foo).value(gteq?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 33 } }

          it 'is successful' do
            assert_successful result
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

          it 'is raises error' do
            expect { result }.to raise_error(NoMethodError)
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is raises error' do
            expect { result }.to raise_error(ArgumentError, 'comparison of String with 23 failed')
          end
        end

        describe 'with invalid input type' do
          let(:input) { { foo: [] } }

          it 'is raises error' do
            expect { result }.to raise_error(NoMethodError)
          end
        end

        describe 'with equal input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with less than input' do
          let(:input) { { foo: 0 } }

          it 'is not successful' do
            refute_successful result, ['must be greater than or equal to 23']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).filled(gteq?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 33 } }

          it 'is successful' do
            assert_successful result
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
            refute_successful result, ['must be filled', 'must be greater than or equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { foo: '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be greater than or equal to 23']
          end
        end

        describe 'with invalid input type' do
          let(:input) { { foo: [] } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be greater than or equal to 23']
          end
        end

        describe 'with equal input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with less than input' do
          let(:input) { { foo: 0 } }

          it 'is not successful' do
            refute_successful result, ['must be greater than or equal to 23']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations

            validations do
              optional(:foo).maybe(gteq?: 23)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { foo: 33 } }

          it 'is successful' do
            assert_successful result
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

          it 'is raises error' do
            expect { result }.to raise_error(ArgumentError, 'comparison of String with 23 failed')
          end
        end

        describe 'with invalid input type' do
          let(:input) { { foo: [] } }

          it 'is raises error' do
            expect { result }.to raise_error(NoMethodError)
          end
        end

        describe 'with equal input' do
          let(:input) { { foo: 23 } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with less than input' do
          let(:input) { { foo: 0 } }

          it 'is not successful' do
            refute_successful result, ['must be greater than or equal to 23']
          end
        end
      end
    end
  end
end
