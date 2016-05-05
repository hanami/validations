require 'test_helper'

describe 'Predicates: custom' do
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

    # See: https://github.com/dry-rb/dry-validation/issues/140
    # @group = Class.new do
    #   include Hanami::Validations

    #   validations do
    #     configure do
    #       config.messages_file = 'test/fixtures/messages.yml'

    #       def cool?(current)
    #         current == 'cool'
    #       end
    #     end

    #     required(:details).schema do
    #       required(:foo) { cool? }
    #     end
    #   end
    # end

    @nested = Class.new do
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

    @with_predicates = Class.new do
      include Hanami::Validations

      validations do
        configure do
          config.messages_file = 'test/fixtures/messages.yml'
          config.predicates    = Module.new do
            include Hanami::Validations::Predicates

            predicate(:email?) do |current|
              current.match(/@/)
            end
          end
        end

        required(:foo) { email? }
      end
    end
  end

  describe 'with custom predicate' do
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
    describe 'with valid input' do
      let(:input) { { foo: 'test@hanamirb.org' } }

      it 'is successful' do
        result = @with_predicates.new(input).validate
        result.must_be :success?
      end
    end

    describe 'with invalid input' do
      let(:input) { { foo: 'test' } }

      it 'is successful' do
        result = @with_predicates.new(input).validate

        result.wont_be :success?
        result.messages.fetch(:foo).must_equal ['must be an email']
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
    # See: https://github.com/dry-rb/dry-validation/issues/140
    # it 'can access to custom predicates from nested groups' do
    #   result = @group.new(details: { foo: 'bar' }).validate

    #   result.wont_be :success?
    #   result.messages[:details][:foo].must_equal ['must be cool']
    # end

    it 'allows groups to define their own custom predicates' do
      result = @nested.new(details: { foo: 2 }).validate

      result.wont_be :success?
      result.messages[:details][:foo].must_equal ['must be odd']
    end
  end
end
