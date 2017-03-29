require 'test_helper'

describe 'Predicates: custom' do
  describe 'with custom predicate' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        def self.name
          'Validator'
        end

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
        include Hanami::Validations::Form

        def self.name
          'Validator'
        end

        predicates(
          Module.new do
            include Hanami::Validations::Predicates

            self.messages_path = 'test/fixtures/messages.yml'

            predicate(:email?) do |current|
              current.match(/@/)
            end
          end
        )

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
        include Hanami::Validations::Form

        def self.name
          'Validator'
        end

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

  describe 'with custom predicate with predicate macro' do
    before do
      @validator = Class.new do
        include Hanami::Validations::Form

        def self.name
          'Validator'
        end

        predicate :api_date?, message: 'must be in iso8601 format' do |value|
          begin
            Date.iso8601(value)
            true
          rescue ArgumentError
            false
          end
        end

        validations do
          required(:id).filled
          required(:confirmed_at).filled(:api_date?)
        end
      end
    end

    describe 'with valid data' do
      let(:input) { { id: 1, confirmed_at: Date.today.iso8601 } }

      it 'is successful' do
        result = @validator.new(input).validate
        result.must_be :success?
      end
    end

    describe 'with invalid data' do
      let(:input) { { id: 1, confirmed_at: 'foo' } }

      it 'is not successful' do
        result = @validator.new(input).validate

        result.wont_be :success?
        result.messages.fetch(:confirmed_at).must_equal ['must be in iso8601 format']
      end
    end
  end

  describe 'without custom predicate' do
    it 'raises error if try to use an unknown predicate' do
      exception = lambda do
        Class.new do
          include Hanami::Validations::Form

          def self.name
            'Validator'
          end

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
        include Hanami::Validations::Form

        def self.name
          'Validator'
        end

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
