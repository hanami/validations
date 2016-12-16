require 'test_helper'

describe 'Predicates: Format' do
  include TestUtils

  describe 'with required' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          required(:foo) { format?(/bar/) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { 'foo' => 'bar baz' } }

      it 'is successful' do
        assert_successful result
      end
    end

    describe 'with missing input' do
      let(:input) { {} }

      # FIXME: dry-v ticket: has an invalid format
      it 'is not successful' do
        refute_successful result, ['is missing']
      end
    end

    describe 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is not successful' do
        refute_successful result, ['is in invalid format']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        refute_successful result, ['is in invalid format']
      end
    end

    describe 'with invalid type' do
      let(:input) { { 'foo' => { 'a' => '1' } } }

      it 'raises error' do
        -> { result }.must_raise TypeError
      end
    end

    describe 'with invalid input' do
      let(:input) { { 'foo' => 'wat' } }

      it 'is not successful' do
        refute_successful result, ['is in invalid format']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          optional(:foo) { format?(/bar/) }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { 'foo' => 'bar baz' } }

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
        refute_successful result, ['is in invalid format']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        refute_successful result, ['is in invalid format']
      end
    end

    describe 'with invalid type' do
      let(:input) { { 'foo' => { 'a' => '1' } } }

      it 'raises error' do
        -> { result }.must_raise TypeError
      end
    end

    describe 'with invalid input' do
      let(:input) { { 'foo' => 'wat' } }

      it 'is not successful' do
        refute_successful result, ['is in invalid format']
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
              required(:foo).value(format?: /bar/)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => 'bar baz' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => { 'a' => '1' } } }

          it 'raises error' do
            -> { result }.must_raise TypeError
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => 'wat' } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).filled(format?: /bar/)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => 'bar baz' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            refute_successful result, ['must be filled']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => { 'a' => '1' } } }

          it 'raises error' do
            -> { result }.must_raise TypeError
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => 'wat' } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).maybe(format?: /bar/)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => 'bar baz' } }

          it 'is successful' do
            assert_successful result
          end
        end

        describe 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            refute_successful result, ['is missing']
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

          it 'is not successful'
          # it 'is not successful' do
          #   refute_successful result, ['is in invalid format']
          # end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => 'wat' } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
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
              optional(:foo).value(format?: /bar/)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => 'bar baz' } }

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
            refute_successful result, ['is in invalid format']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => { 'a' => '1' } } }

          it 'raises error' do
            -> { result }.must_raise TypeError
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => 'wat' } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).filled(format?: /bar/)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => 'bar baz' } }

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
            refute_successful result, ['must be filled']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled']
          end
        end

        describe 'with invalid type' do
          let(:input) { { 'foo' => { 'a' => '1' } } }

          it 'raises error' do
            -> { result }.must_raise TypeError
          end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => 'wat' } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).maybe(format?: /bar/)
            end
          end
        end

        describe 'with valid input' do
          let(:input) { { 'foo' => 'bar baz' } }

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

          it 'raises error'
          # it 'raises error' do
          #   -> { result }.must_raise TypeError
          # end
        end

        describe 'with invalid input' do
          let(:input) { { 'foo' => 'wat' } }

          it 'is not successful' do
            refute_successful result, ['is in invalid format']
          end
        end
      end
    end
  end
end
