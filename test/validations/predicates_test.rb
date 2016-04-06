require 'test_helper'
require 'hanami/validations/predicate'
require 'hanami/validations/predicates'

describe Hanami::Validations::Predicates::Presence do
  describe '#call' do
    it 'returns true if the given value is not nil' do
      predicate = Hanami::Validations::Predicates::Presence.new
      predicate.call(1).must_equal true
    end

    it 'returns false if the given value is nil' do
      predicate = Hanami::Validations::Predicates::Presence.new
      predicate.call(nil).must_equal false
    end
  end
end

describe Hanami::Validations::Predicates::Inclusion do
  describe '#call' do
    it 'returns true if the given value is included in the collection' do
      predicate = Hanami::Validations::Predicates::Inclusion.new
      predicate.call('a', %w(a b c)).must_equal true
    end

    it 'returns false if the given value is not included in the collection' do
      predicate = Hanami::Validations::Predicates::Inclusion.new
      predicate.call(:a, %w(a b c)).must_equal false
    end
  end
end
