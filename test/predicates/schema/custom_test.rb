require 'test_helper'

describe 'Predicates: custom' do
  describe 'with custom predicate' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          configure do
            config.messages_file = 'test/fixtures/messages.yml'

            def email?(current)
              current.match(/\@/)
            end
          end

          required(:foo) { email? }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 'test@hanamirb.org' } }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 'test' } }

      it 'is successful' do
        result = @validator.new(input).validate

        result.wont_be :success?
        result.messages.fetch(:foo).must_equal ['must be an email']
      end
    end
  end

  describe 'with custom predicates as module' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        predicates Module.new {
          include Hanami::Validations::Predicates

          self.messages = 'test/fixtures/messages.yml'

          predicate(:email?) do |current|
            current.match(/@/)
          end
        }

        validations do
          required(:foo) { email? }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 'test@hanamirb.org' } }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 'test' } }

      it 'is successful' do
        result = @validator.new(input).validate

        result.wont_be :success?
        result.messages.fetch(:foo).must_equal ['must be an email']
      end
    end
  end

  describe 'with custom predicate within predicates block' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        predicate :url?, message: 'must be an URL' do |current|
          current.start_with?('http')
        end

        validations do
          required(:foo) { url? }
        end
      end
    end

    describe 'with valid input' do
      let(:input) { { foo: 'http://hanamirb.org' } }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 'test' } }

      it 'is successful' do
        result = @validator.new(input).validate

        result.wont_be :success?
        result.messages.fetch(:foo).must_equal ['must be an URL']
      end
    end
  end

  describe 'without custom predicate' do
    it 'raises error if try to use an unknown predicate' do
      exception = lambda do
        Class.new do
          include Hanami::Validations

          validations do
            required(:foo) { email? }
          end
        end
      end.must_raise(ArgumentError)

      exception.message.must_equal '+email?+ is not a valid predicate name'
    end
  end

  describe 'with nested validations' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validations do
          required(:details).schema do
            configure do
              config.messages_file = 'test/fixtures/messages.yml'

              def odd?(current)
                current.odd?
              end
            end

            required(:foo) { odd? }
          end
        end
      end
    end

    it 'allows groups to define their own custom predicates' do
      result = @validator.new(details: { foo: 2 }).validate

      result.wont_be :success?
      result.messages[:details][:foo].must_equal ['must be odd']
    end
  end
end
