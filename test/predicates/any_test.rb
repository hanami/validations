require 'test_helper'

describe 'Predicates: any?' do
  describe 'when collection' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validates(:name) { any? { |e| e == 'a' } }
      end
    end

    it 'raises error for missing data' do
      exception = -> { @validator.new({}).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `any?' for nil:NilClass"
    end

    it 'raises error for missing nil data' do
      exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `any?' for nil:NilClass"
    end

    it 'returns failing result for blank data' do
      result = @validator.new(name: '').validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, '')
      ]
    end

    it 'returns failing result for empty array' do
      result = @validator.new(name: []).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, [])
      ]
    end

    it 'returns failing result for empty Hash' do
      result = @validator.new(name: {}).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, {})
      ]
    end

    it 'returns failing result for filled string with wrong data' do
      result = @validator.new(name: 'xyz').validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, 'xyz')
      ]
    end

    it 'returns successful result for filled string with valid string' do
      result = @validator.new(name: 'abc').validate

      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing result for filled array with wrong data' do
      result = @validator.new(name: ['abc']).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, ['abc'])
      ]
    end

    it 'returns successful result for filled array with valid data' do
      result = @validator.new(name: ['a']).validate

      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing result for filled hash' do
      result = @validator.new(name: { 'a' => 'abc' }).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, { 'a' => 'abc' })
      ]
    end
  end

  describe 'when hash' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validates(:name) { any? { |_, v| v == 'yes' } }
      end
    end

    it 'raises error for missing data' do
      exception = -> { @validator.new({}).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `any?' for nil:NilClass"
    end

    it 'raises error for missing nil data' do
      exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `any?' for nil:NilClass"
    end

    it 'returns failing result for blank data' do
      result = @validator.new(name: '').validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, '')
      ]
    end

    it 'returns failing result for empty array' do
      result = @validator.new(name: []).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, [])
      ]
    end

    it 'returns failing result for empty Hash' do
      result = @validator.new(name: {}).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, {})
      ]
    end

    it 'returns failing result for filled string with wrong data' do
      result = @validator.new(name: 'xyz').validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, 'xyz')
      ]
    end

    it 'returns failing result for filled string with valid string' do
      result = @validator.new(name: 'abc').validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, 'abc')
      ]
    end

    it 'returns failing result for filled array with wrong data' do
      result = @validator.new(name: ['abc']).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, ['abc'])
      ]
    end

    it 'returns failing result for filled array with valid data' do
      result = @validator.new(name: ['a']).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, ['a'])
      ]
    end

    it 'returns failing result for filled hash with wrong data' do
      result = @validator.new(name: { 'a' => 'abc' }).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, { 'a' => 'abc' })
      ]
    end

    it 'returns failing result for filled hash with valid data' do
      result = @validator.new(name: { 'a' => 'no', 'b' => 'yes' }).validate

      result.must_be :success?
      result.errors.must_be_empty
    end
  end

  describe 'when symbol' do
    before do
      @validator = Class.new do
        include Hanami::Validations

        validates(:name) { any?(&:odd?) }
      end
    end

    it 'raises error for missing data' do
      exception = -> { @validator.new({}).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `any?' for nil:NilClass"
    end

    it 'raises error for missing nil data' do
      exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
      exception.message.must_equal "undefined method `any?' for nil:NilClass"
    end

    it 'returns failing result for blank data' do
      result = @validator.new(name: '').validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, '')
      ]
    end

    it 'returns failing result for empty array' do
      result = @validator.new(name: []).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, [])
      ]
    end

    it 'returns failing result for empty Hash' do
      result = @validator.new(name: {}).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, {})
      ]
    end

    it 'raises error for filled string' do
      exception = -> { @validator.new(name: 'xyz').validate }.must_raise(NoMethodError)
      exception.message.must_equal %(undefined method `odd?' for "x":String)
    end

    it 'raises error for filled array with wrong data type' do
      exception = -> { @validator.new(name: ['abc']).validate }.must_raise(NoMethodError)
      exception.message.must_equal %(undefined method `odd?' for "abc":String)
    end

    it 'returns successful result for filled array with valid data' do
      result = @validator.new(name: [2, 1, 4]).validate

      result.must_be :success?
      result.errors.must_be_empty
    end

    it 'returns failing result for filled array with wrong data' do
      result = @validator.new(name: [2]).validate

      result.wont_be :success?
      result.errors.for(:name).must_equal [
        Hanami::Validations::Error.new(:name, :any?, nil, [2])
      ]
    end

    it 'raises error for filled hash' do
      exception = -> { @validator.new(name: { 'a' => 'abc' }).validate }.must_raise(NoMethodError)
      exception.message.must_equal %(undefined method `odd?' for ["a", "abc"]:Array)
    end
  end
end
