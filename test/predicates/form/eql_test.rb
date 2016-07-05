require 'test_helper'

describe 'Predicates: Eql' do
  include TestUtils

  describe 'with required' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          required(:foo) { eql?('23') }
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
        refute_successful result, ['is missing', 'must be equal to 23']
      end
    end

    describe 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is not successful' do
        refute_successful result, ['must be equal to 23']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        refute_successful result, ['must be equal to 23']
      end
    end
  end

  describe 'with optional' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        validations do
          optional(:foo) { eql?('23') }
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

      it 'is not successful' do
        refute_successful result, ['must be equal to 23']
      end
    end

    describe 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        refute_successful result, ['must be equal to 23']
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
              required(:foo).value(eql?: '23')
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
            refute_successful result, ['is missing', 'must be equal to 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            refute_successful result, ['must be equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be equal to 23']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).filled(eql?: '23')
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
            refute_successful result, ['is missing', 'must be equal to 23']
          end
        end

        describe 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be equal to 23']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              required(:foo).maybe(eql?: '23')
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
            refute_successful result, ['is missing', 'must be equal to 23']
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
      end
    end

    describe 'with optional' do
      describe 'with value' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).value(eql?: '23')
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

          it 'is not successful' do
            refute_successful result, ['must be equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be equal to 23']
          end
        end
      end

      describe 'with filled' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).filled(eql?: '23')
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

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be equal to 23']
          end
        end

        describe 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            refute_successful result, ['must be filled', 'must be equal to 23']
          end
        end
      end

      describe 'with maybe' do
        before do
          @validator = Class.new do
            include Hanami::Validations::Form

            validations do
              optional(:foo).maybe(eql?: '23')
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
      end
    end
  end
end
