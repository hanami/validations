require 'test_helper'

describe 'Predicates: custom' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      predicate :equals? do |current, expected|
        current == expected
      end

      validates(:name) { equals?(23) }
    end

    @another = Class.new do
      include Hanami::Validations

      validates(:name) { equals?(1) }
    end

    @group = Class.new do
      include Hanami::Validations

      predicate :cool? do |current|
        current == 'cool'
      end

      group :details do
        validates(:foo) { cool? }
      end
    end

    @nested = Class.new do
      include Hanami::Validations

      group :details do
        predicate :odd? do |current|
          current.odd?
        end

        validates(:number) { odd? }
      end
    end

    @outer = Class.new do
      include Hanami::Validations

      validates(:id) { even? }

      group :details do
        predicate :even? do |current|
          current.even?
        end
      end
    end

    @native = Class.new do
      include Hanami::Validations

      predicate(:odd?, &:odd?)
      validates(:num) { int? && odd? }
    end
  end

  it 'uses custom predicate' do
    result = @validator.new(name: 23).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'custom validators are not available to other validators' do
    -> { @another.new(name: 1).validate }.must_raise(Hanami::Validations::UnknownPredicateError)
  end

  it 'can access to custom predicates from nested groups' do
    result = @group.new(details: { foo: 'cool' }).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'allows groups to define their own custom predicates' do
    result = @nested.new(details: { number: 23 }).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'outer group cannot access inner groups custom validations' do
    -> { @outer.new(id: 12).validate }.must_raise(Hanami::Validations::UnknownPredicateError)
  end

  it 'allows to define custom predicates with native methods passed as symbols' do
    result = @native.new(num: 10).validate

    result.wont_be :success?
    result.errors.fetch(:num).must_equal [
      Hanami::Validations::Error.new(:num, :odd?, nil, 10)
    ]
  end
end
