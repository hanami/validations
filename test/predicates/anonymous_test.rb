require 'test_helper'

describe 'Anonymous predicate' do
  before do
    @none = Class.new do
      include Hanami::Validations
    end

    @key = Class.new do
      include Hanami::Validations

      key(:name)
    end

    @empty = Class.new do
      include Hanami::Validations

      validates(:name) {}
    end

    @false = Class.new do
      include Hanami::Validations

      validates(:name) { false }
    end
  end

  it 'is successful without any validation' do
    result = @none.new({}).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'is successful without block' do
    result = @key.new(name: 'L', age: 33).validate

    result.must_be :success?
    result.errors.must_be_empty
    result.output.must_equal(name: 'L')
  end

  it 'is failing with empty block' do
    result = @empty.new(name: 'foo').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :base, nil, nil)
    ]
  end

  it 'is failing with block returning false' do
    result = @false.new(name: 'foo').validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Error.new(:name, :base, nil, false)
    ]
  end
end
