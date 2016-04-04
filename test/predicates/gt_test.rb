require 'test_helper'

describe 'Predicates: Gt' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      key(:foo) { gt?(23) }
    end
  end

  describe 'with valid input' do
    let(:input) { { foo: 33 } }

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

    it 'returns error message' do
      result = @validator.new(input).validate
      result.messages.fetch(:foo).must_equal ['is missing', 'must be greater than 23']
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

    it 'is raises error' do
      exception = -> { @validator.new(input).validate }.must_raise(ArgumentError)
      exception.message.must_equal 'comparison of String with 23 failed'
    end
  end

  describe 'with invalid input type' do
    let(:input) { { foo: [] } }

    it 'is raises error' do
      -> { @validator.new(input).validate }.must_raise(NoMethodError)
    end
  end

  describe 'with equal input' do
    let(:input) { { foo: 23 } }

    it 'is not successful' do
      result = @validator.new(input).validate
      result.wont_be :success?
    end

    it 'returns error message' do
      result = @validator.new(input).validate
      result.messages.fetch(:foo).must_equal ['must be greater than 23']
    end
  end

  describe 'with less than input' do
    let(:input) { { foo: 0 } }

    it 'is not successful' do
      result = @validator.new(input).validate
      result.wont_be :success?
    end

    it 'returns error message' do
      result = @validator.new(input).validate
      result.messages.fetch(:foo).must_equal ['must be greater than 23']
    end
  end
end
