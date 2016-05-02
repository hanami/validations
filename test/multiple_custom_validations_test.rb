require 'test_helper'

describe Hanami::Validations do
  describe 'with multiple custom validations' do
    it 'is valid' do
      validator = MultilpeCustomValidationsTest.new(name: 'Pepe')

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it 'fails on the first validation' do
      validator = MultilpeCustomValidationsTest.new(name: 'pepe')

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_equal [Hanami::Validations::Error.new('name', :case, true, 'pepe')]
    end

    it 'fails on the second validation' do
      validator = MultilpeCustomValidationsTest.new(name: 'Pepe Sanchez')

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_equal [Hanami::Validations::Error.new('name', :single_word, true, 'Pepe Sanchez')]
    end

    it 'fails on both validations' do
      validator = MultilpeCustomValidationsTest.new(name: 'pepe sanchez')

      validator.valid?.must_equal false
      error = validator.errors.for('name')
      error.must_equal [
      	Hanami::Validations::Error.new('name', :case, true, 'pepe sanchez'),
      	Hanami::Validations::Error.new('name', :single_word, true, 'pepe sanchez')
      ]
    end
  end
end
