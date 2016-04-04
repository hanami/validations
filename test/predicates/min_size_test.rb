require 'test_helper'

describe 'Predicates: Min Size' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      key(:foo) { min_size?(3) }
    end
  end

  describe 'with valid input' do
    let(:input) { { foo: [1, 2, 3] } }

    it 'is successful' do
      result = @validator.new(input).validate
      result.must_be :success?
    end

    it 'has not error messages' do
      result = @validator.new(input).validate
      result.messages[:foo].must_be_nil
    end
  end

  describe 'with missing input' do
    let(:input) { {} }

    it 'is not successful' do
      result = @validator.new(input).validate
      result.wont_be :success?
    end

    # FIXME: open dry-v ticket - misleading error message
    it 'returns error message' do
      result = @validator.new(input).validate
      result.messages.fetch(:foo).must_equal ['is missing', 'size cannot be less than 3']
    end
  end

  describe 'with nil input' do
    let(:input) { { foo: nil } }

    it 'is raises error' do
      -> { @validator.new(input).validate }.must_raise(NoMethodError)
    end
  end

  describe 'with blank input' do
    let(:input) { { foo: '' } }

    it 'is not successful' do
      result = @validator.new(input).validate
      result.wont_be :success?
    end

    # FIXME: open dry-v ticket - misleading error message
    it 'returns error message' do
      result = @validator.new(input).validate
      result.messages.fetch(:foo).must_equal ['size cannot be less than 3']
    end
  end

  describe 'with invalid input' do
    let(:input) { { foo: { a: 1, b: 2 } } }

    it 'is not successful' do
      result = @validator.new(input).validate
      result.wont_be :success?
    end

    it 'returns error message' do
      result = @validator.new(input).validate
      result.messages.fetch(:foo).must_equal ['size cannot be less than 3']
    end
  end
end
