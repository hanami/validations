require 'test_helper'

describe 'Predicates: Type' do
  include TestUtils

  describe 'with required' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          required(:foo) { type?(Integer) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { 'foo' => '23' } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        refute_successful result, ['is missing', 'must be Integer']
      end
    end

    describe 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is not successful' do
        refute_successful result, ['is missing', 'must be Integer']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        refute_successful result, ['must be Integer']
      end
    end

    describe 'with invalid type' do
      let(:input) { { 'foo' => ['x'] } }

      it 'is not successful' do
        refute_successful result, ['is missing', 'must be Integer']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          optional(:foo) { type?(Integer) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { 'foo' => '23' } }

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
      let(:input) { { 'foo' => nil } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        refute_successful result, ['must be Integer']
      end
    end

    describe 'with invalid type' do
      let(:input) { { 'foo' => ['x'] } }

      it 'is not successful'
      # it 'is not successful' do
      #   refute_successful result, ['must be Integer']
      # end
    end
  end

  describe 'as macro' do
    describe 'with required' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).value(type?: Integer)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be Integer']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be Integer']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be Integer']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['must be Integer']
          # end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).filled(type?: Integer)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be Integer']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be Integer']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be Integer']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['must be Integer']
          # end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).maybe(type?: Integer)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be Integer']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['must be Integer']
          # end
        end
      end
    end

    describe 'with optional' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).value(type?: Integer)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '23' } }

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
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be Integer']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['must be Integer']
          # end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).filled(type?: Integer)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '23' } }

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
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be Integer']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['must be Integer']
          # end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).maybe(type?: Integer)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '23' } }

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
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['must be Integer']
          # end
        end
      end
    end
  end
end
