require 'test_helper'
require 'hanami/validations/rules'

describe Hanami::Validations::Rules do
  it 'returns true if the predicate is satisfied' do
    rules = Hanami::Validations::Rules.new(:name, -> { present? })

    result = rules.call(Hanami::Validations::Input.new, Hanami::Validations::Output.new)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :present?, nil, nil)]

    result = rules.call(Hanami::Validations::Input.new(name: 1), Hanami::Validations::Output.new)
    result.errors.must_be_empty

    result = rules.call(Hanami::Validations::Input.new(name: nil), Hanami::Validations::Output.new)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :present?, nil, nil)]
  end

  it 'returns true if the predicate is satisfied with the given ' do
    rules = Hanami::Validations::Rules.new(:name, -> { include?([1, 2, 3]) })

    result = rules.call(Hanami::Validations::Input.new(name: 1), Hanami::Validations::Output.new)
    result.errors.must_be_empty

    result = rules.call(Hanami::Validations::Input.new(name: nil), Hanami::Validations::Output.new)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :include?, [1, 2, 3], nil)]

    result = rules.call(Hanami::Validations::Input.new(name: 12), Hanami::Validations::Output.new)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :include?, [1, 2, 3], 12)]
  end

  it 'returns true if all the predicates are satisfied' do
    rules = Hanami::Validations::Rules.new(:name, -> { present? && include?(1..3) })

    result = rules.call(Hanami::Validations::Input.new(name: nil), Hanami::Validations::Output.new)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :present?, nil, nil)]

    result = rules.call(Hanami::Validations::Input.new(name: 4), Hanami::Validations::Output.new)
    result.errors.must_equal [Hanami::Validations::Error.new(:name, :include?, 1..3, 4)]

    result = rules.call(Hanami::Validations::Input.new(name: 1), Hanami::Validations::Output.new)
    result.errors.must_be_empty
  end

  it 'returns true if at least one predicate is satisfied' do
    rules = Hanami::Validations::Rules.new(:name, -> { present? || include?(1..3) })

    result = rules.call(Hanami::Validations::Input.new(name: nil), Hanami::Validations::Output.new)
    result.errors.must_equal [
      Hanami::Validations::Error.new(:name, :present?, nil, nil),
      Hanami::Validations::Error.new(:name, :include?, 1..3, nil)
    ]

    # Explanation: 4 isn't included in 1..3 range, but because the first
    # validation passes, it returns true.
    #
    # This is the way Ruby works with `||` operator: once a condition is true,
    # it stops to evaluate the other ones.
    # For instance, this snippet will never raise an exception:
    #
    #   `true || raise("boom")`
    result = rules.call(Hanami::Validations::Input.new(name: 4), Hanami::Validations::Output.new)
    result.errors.must_be_empty

    result = rules.call(Hanami::Validations::Input.new(name: 1), Hanami::Validations::Output.new)
    result.errors.must_be_empty
  end
end
