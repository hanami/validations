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
  end

  it 'uses custom predicate' do
    result = @validator.new(name: 23).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'is registered globally' do
    result = @another.new(name: 1).validate

    result.must_be :success?
    result.errors.must_be_empty
  end
end
