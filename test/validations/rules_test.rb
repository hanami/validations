require 'test_helper'
require 'hanami/validations/rules'

describe Hanami::Validations::Rules do
  it 'returns true if the predicate is satisfied' do
    rules = Hanami::Validations::Rules.new(:name, -> { present? })

    result = rules.call({})
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :present?, nil, nil)]

    result = rules.call(name: 1)
    result.errors.must_be_empty

    result = rules.call(name: nil)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :present?, nil, nil)]
  end

  it 'returns true if the predicate is satisfied with the given ' do
    rules = Hanami::Validations::Rules.new(:name, -> { inclusion?([1, 2, 3]) })

    result = rules.call(name: 1)
    result.errors.must_be_empty

    result = rules.call(name: nil)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :inclusion?, [1, 2, 3], nil)]

    result = rules.call(name: 12)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :inclusion?, [1, 2, 3], 12)]
  end

  it 'returns true if all the predicates are satisfied' do
    rules = Hanami::Validations::Rules.new(:name, -> { present? && inclusion?(1..3) })

    result = rules.call(name: nil)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :present?, nil, nil)]

    result = rules.call(name: 4)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :inclusion?, 1..3, 4)]

    result = rules.call(name: 1)
    result.errors.must_be_empty
  end

  it 'returns true if at least one predicate is satisfied' do
    rules = Hanami::Validations::Rules.new(:name, -> { present? || inclusion?(1..3) })

    result = rules.call(name: nil)
    result.errors.must_equal [
      Hanami::Validations::Error.new(:name, :present?, nil, nil),
      Hanami::Validations::Error.new(:name, :inclusion?, 1..3, nil),
    ]

    result = rules.call(name: 4)
    result.errors.must_equal [
      Hanami::Validations::Error.new(:name, :inclusion?, 1..3, 4),
    ]

    result = rules.call(name: 1)
    result.errors.must_be_empty
  end
end
