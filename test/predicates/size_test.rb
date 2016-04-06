require 'test_helper'

describe 'Predicates: size?' do
  describe 'when fixed' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validates(:name) { size?(4) }
      end
    end

    it 'raises error for missing data' do
      exception = -> { @validator.new({}).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `size' for nil:NilClass"
    end

    it 'raises error for missing nil' do
      exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `size' for nil:NilClass"
    end

    it 'raises error for missing nil' do
      exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `size' for nil:NilClass"
    end

    it 'returns failing result for blank string' do
      result = @validator.new(name: '').validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4, 0)
      ]
    end

    it 'returns failing result for empty array' do
      result = @validator.new(name: []).validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4, 0)
      ]
    end

    it 'returns failing result for empty hash' do
      result = @validator.new(name: {}).validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4, 0)
      ]
    end

    it 'returns failing result for bigger string' do
      result = @validator.new(name: 'abcde').validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4, 5)
      ]
    end

    it 'returns failing result for bigger array' do
      result = @validator.new(name: [1, 2, 3, 4, 5, 6]).validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4, 6)
      ]
    end

    it 'returns failing result for bigger hash' do
      result = @validator.new(name: { a: 1, b: 2, c: 3, d: 4, e: 5 }).validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4, 5)
      ]
    end

    it 'returns failing result for exact size string' do
      result = @validator.new(name: "\x80\u3042").validate

      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing result for exact size array' do
      result = @validator.new(name: [1, 2, 3, 4]).validate

      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing result for exact size hash' do
      result = @validator.new(name: { a: 1, b: 2, c: 3, d: 4 }).validate

      result.must_be :success?
      result.errors.must_be_empty
    end
  end

  describe 'when range' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validates(:name) { size?(4..5) }
      end
    end

    it 'raises error for missing data' do
      exception = -> { @validator.new({}).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `size' for nil:NilClass"
    end

    it 'raises error for missing nil' do
      exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `size' for nil:NilClass"
    end

    it 'raises error for missing nil' do
      exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `size' for nil:NilClass"
    end

    it 'returns failing result for blank string' do
      result = @validator.new(name: '').validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4..5, 0)
      ]
    end

    it 'returns failing result for empty array' do
      result = @validator.new(name: []).validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4..5, 0)
      ]
    end

    it 'returns failing result for empty hash' do
      result = @validator.new(name: {}).validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4..5, 0)
      ]
    end

    it 'returns failing result for bigger string' do
      result = @validator.new(name: 'abcdefgh').validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4..5, 8)
      ]
    end

    it 'returns failing result for bigger array' do
      result = @validator.new(name: [1, 2, 3, 4, 5, 6]).validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4..5, 6)
      ]
    end

    it 'returns failing result for bigger hash' do
      result = @validator.new(name: { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6 }).validate

      result.wont_be :success?
      result.errors.fetch(:name).must_equal [
        Hanami::Validations::Rules::Error.new(:name, :size?, 4..5, 6)
      ]
    end

    it 'returns failing result for exact size string' do
      result = @validator.new(name: "\x80\u3042").validate

      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing result for exact size array' do
      result = @validator.new(name: [1, 2, 3, 4]).validate

      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing result for exact size hash' do
      result = @validator.new(name: { a: 1, b: 2, c: 3, d: 4 }).validate

      result.must_be :success?
      result.errors.must_be_empty
    end
  end
end
