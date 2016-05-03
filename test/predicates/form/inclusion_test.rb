require 'test_helper'

describe 'Predicates: Inclusion' do
  include TestUtils

  describe 'with required' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          required(:foo) { inclusion?(%w(1 3 5)) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { 'foo' => '3' } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        refute_successful result, ['is missing', 'must be one of: 1, 3, 5']
      end
    end

    describe 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is not successful' do
        refute_successful result, ['must be one of: 1, 3, 5']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        refute_successful result, ['must be one of: 1, 3, 5']
      end
    end

    describe 'with invalid type' do
      let(:input) { { 'foo' => { 'a' => '1' } } }

      it 'is not successful' do
        refute_successful result, ['must be one of: 1, 3, 5']
      end
    end

    describe 'with invalid input' do
      let(:input) { { 'foo' => '4' } }

      it 'is not successful' do
        refute_successful result, ['must be one of: 1, 3, 5']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          optional(:foo) { inclusion?(%w(1 3 5)) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { 'foo' => '3' } }

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

      it 'is not successful' do
        refute_successful result, ['must be one of: 1, 3, 5']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        refute_successful result, ['must be one of: 1, 3, 5']
      end
    end

    describe 'with invalid type' do
      let(:input) { { 'foo' => { 'a' => '1' } } }

      it 'is not successful' do
        refute_successful result, ['must be one of: 1, 3, 5']
      end
    end

    describe 'with invalid input' do
      let(:input) { { 'foo' => '4' } }

      it 'is not successful' do
        refute_successful result, ['must be one of: 1, 3, 5']
      end
    end
  end

  describe 'as macro' do
    describe 'with required' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).value(inclusion?: %w(1 3 5))
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '3' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be one of: 1, 3, 5']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => { 'a' => '1' } } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => '4' } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).filled(inclusion?: %w(1 3 5))
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '3' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be one of: 1, 3, 5']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be one of: 1, 3, 5']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be one of: 1, 3, 5']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => { 'a' => '1' } } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => '4' } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).maybe(inclusion?: %w(1 3 5))
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '3' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing', 'must be one of: 1, 3, 5']
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
          let(:input) { { 'foo' => { 'a' => '1' } } }

          # See: https://github.com/dry-rb/dry-validation/issues/129#issuecomment-216534179
          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['must be one of: 1, 3, 5']
          # end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => '4' } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end
      end
    end

    describe 'with optional' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).value(inclusion?: %w(1 3 5))
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '3' } }

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

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => { 'a' => '1' } } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => '4' } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).filled(inclusion?: %w(1 3 5))
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '3' } }

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

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be one of: 1, 3, 5']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be one of: 1, 3, 5']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => { 'a' => '1' } } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => '4' } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).maybe(inclusion?: %w(1 3 5))
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => '3' } }

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
          let(:input) { { 'foo' => { 'a' => '1' } } }

          # See: https://github.com/dry-rb/dry-validation/issues/129#issuecomment-216534179
          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['must be one of: 1, 3, 5']
          # end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => '4' } }

          it 'is not successful' do
            refute_successful result, ['must be one of: 1, 3, 5']
          end
        end
      end
    end
  end
end
