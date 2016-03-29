require 'test_helper'

describe Hanami::Validations do
  describe 'a validator instance' do
    it "is valid" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '0', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "add a default error if it is not valid" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '99', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('age')
      error.must_include Hanami::Validations::Error.new('age', :custom, true, 99)
    end

    it "adds an error overriding its values" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '1', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('some_namespace.name')
      error.must_include Hanami::Validations::Error.new('name', :another_validation, 'expected: 1', 'actual: 1', 'some_namespace')
    end

    it "adds an error for another attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '2', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('some_namespace.name')
      error.must_include Hanami::Validations::Error.new('name', :another_validation, 'expected: 2', 'actual: 2', 'some_namespace')
    end

    it "raises an error when adding an error for another attribute with missing parameters" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '3', address: {street: 'evergreen', number: '742'}
                  )

      -> { validator.valid? }.must_raise ArgumentError
    end

    it "overrides the validation name" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('age')
      error.must_include Hanami::Validations::Error.new('age', :other_validation, true, 4)
    end

    it "asks if a previous validation failed for the default attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('age')
      error.must_equal [Hanami::Validations::Error.new('age', :presence, true, nil)]

      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '5', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('age')
      error.must_equal [Hanami::Validations::Error.new('age', :custom, true, 5)]
    end

    it "asks if a previous validation failed for another attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: '', age: '6', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      validator.errors.for('age').must_be_empty

      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '6', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('age')
      error.must_equal [Hanami::Validations::Error.new('age', :custom, true, 6)]
    end

    it "invokes another validation" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '7', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_equal [Hanami::Validations::Error.new('name', :format, /abc/, 'martin')]

      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'abc', age: '7', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "duplicates the validation instance" do
      validator = ValidateWithInstanceBehaviourTest.new(name: 'martin', age: '8')

      validator.valid?
      first_validator_instance_id = validator.errors.for('age').first.actual

      validator.valid?
      second_validator_instance_id = validator.errors.for('age').first.actual

      first_validator_instance_id.wont_equal second_validator_instance_id
    end

    it "asks for the value of another attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '9', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('age')
      error.must_equal [Hanami::Validations::Error.new('age', :asked_value, true, 9)]
    end

    it "asks for the value of a nested attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '10', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('age')
      error.must_equal [Hanami::Validations::Error.new('age', :asked_nested_value, true, 10)]
    end

    it "invokes a validation on a nested attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'martin', age: '11', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('address.street')
      error.must_include Hanami::Validations::Error.new('street', :format, /abc/, 'evergreen', 'address')
    end
  end
end
