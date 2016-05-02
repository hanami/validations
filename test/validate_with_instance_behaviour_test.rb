require 'test_helper'

describe Hanami::Validations do
  describe 'a validator class' do
    it "duplicates the validation instance" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'duplicates the validation instance',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?
      first_validator_instance_id = validator.errors.for('name').first.actual

      validator.valid?
      second_validator_instance_id = validator.errors.for('name').first.actual

      first_validator_instance_id.wont_equal second_validator_instance_id
    end

    it "is valid" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'is valid',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "adds a default error" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'adds a default error',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_include Hanami::Validations::Error.new(
        'name', :custom, true, 'adds a default error'
      )
    end

    it "adds an error overriding its values" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'adds an error overriding its values',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name_namespace.name')
      error.must_include Hanami::Validations::Error.new(
        'name', :expected_name, 'expected name', 'actual name', 'name_namespace'
      )
    end

    it "adds an error for another attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'adds an error for another attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('age_namespace.age')
      error.must_include Hanami::Validations::Error.new(
        'age', :age_validation, 'expected age', 'actual age', 'age_namespace'
      )
    end

    it "raises an error when adding an error for another attribute with missing parameters" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'raises an error when adding an error for another attribute with missing parameters',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      -> { validator.valid? }.must_raise ArgumentError
    end

    it "overrides the validation name" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'overrides the validation name',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_include Hanami::Validations::Error.new(
        'name', :other_validation, true, 'overrides the validation name'
      )
    end

    it "asks for the value of another attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'asks for the value of another attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_equal [Hanami::Validations::Error.new(
        'name', :custom, true, 'asks for the value of another attribute'
      )]
    end

    it "asks for the value of a nested attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'asks for the value of a nested attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_equal [Hanami::Validations::Error.new(
        'name', :custom, true, 'asks for the value of a nested attribute'
      )]
    end

    it "asks if a previous validation failed for the default attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'asks if a previous validation failed for the default attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_include Hanami::Validations::Error.new(
        'name', :format, /abc/, 'asks if a previous validation failed for the default attribute'
      )
    end

    it "asks if a previous validation failed for another attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'asks if a previous validation failed for another attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_include Hanami::Validations::Error.new(
        'name', :custom, true, 'asks if a previous validation failed for another attribute'
      )
    end

    it "invokes another validation" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'invokes another validation',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_equal [Hanami::Validations::Error.new(
        'name', :format, /abc/, 'invokes another validation'
      )]
    end

    it "invokes another validation on an attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'invokes another validation on an attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_equal [Hanami::Validations::Error.new(
        'name', :format, /abc/, 'invokes another validation on an attribute'
      )]
    end

    it "invokes a validation on a nested attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'invokes a validation on a nested attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('address.street')
      error.must_include Hanami::Validations::Error.new(
        'street', :format, /abc/, 'evergreen', 'address'
      )
    end

    it "asks if any previous validation failed for the default attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'asks if any previous validation failed for the default attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_include Hanami::Validations::Error.new(
        'name', :custom, true, 'asks if any previous validation failed for the default attribute'
      )
    end

    it "asks if any previous validation failed for another attribute" do
      validator = ValidateWithInstanceBehaviourTest.new(
                    name: 'asks if any previous validation failed for another attribute',
                    age: '4', address: {street: 'evergreen', number: '742'}
                  )

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_include Hanami::Validations::Error.new(
        'name', :custom, true, 'asks if any previous validation failed for another attribute'
      )
    end
  end
end