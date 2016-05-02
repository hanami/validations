require 'test_helper'
require 'hanami/validations/predicate'

describe Hanami::Validations::Predicate do
  describe '#initialize' do
    it 'accepts a name' do
      predicate = Hanami::Validations::Predicate.new(:test)
      predicate.call.must_equal false
    end

    it 'accepts a block' do
      predicate = Hanami::Validations::Predicate.new(:test, proc { true })
      predicate.call.must_equal true
    end
  end

  describe '#call' do
    it 'returns false by default' do
      predicate = Hanami::Validations::Predicate.new(:test)
      predicate.call.must_equal false
    end

    it 'returns the returning value of the block' do
      predicate = Hanami::Validations::Predicate.new(:test, proc { 1 == 1 })
      predicate.call.must_equal true
    end

    it 'accepts any argument' do
      predicate = Hanami::Validations::Predicate.new(:test, proc {|num| num == 1 })
      predicate.call(1).must_equal true
    end
  end
end
