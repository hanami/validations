require 'test_helper'

describe Lotus::Validations do
  describe 'nested attributes' do
    it 'builds nested attributes' do
      validator = NestedValidations.new(name: 'John Smith', address: { line_one: '10 High Street' })
      validator.address.line_one.must_equal('10 High Street')
      validator.name.must_equal('John Smith')
    end

    it 'responds with an empty class on nil' do
      NestedValidations.new({}).address.line_one.must_be_nil
    end

    it 'is invalid when nested attributes fail validation' do
      validator = NestedValidations.new(name: 'John Smith', address: { city: 'Melbourne' })
      validator.valid?.must_equal(false)

      expected_error = Lotus::Validations::Error.new(
        attribute_name: 'line_one',
        validation: :presence,
        expected: true,
        namespace: :address)
      line_one_errors = validator.errors.for('address.line_one')
      line_one_errors.must_include(expected_error)

      validator.errors.to_h.must_equal({
        'address.line_one' => [Lotus::Validations::Error.new(
        attribute_name: 'line_one',
        validation: :presence,
        expected: true,
        namespace: :address)]
      })
    end

    it 'is valid when nested attributes pass validation' do
      validator = NestedValidations.new(name: 'John Smith', address: { line_one: '10 High Street' })
      validator.valid?.must_equal(true)
      validator.errors.to_h.must_equal({})
      validator.errors.for('address.line_one').must_equal([])
      validator.address.errors.for(:line_one).must_equal([])
      validator.errors.to_h.must_equal({})
    end

    # Bug
    # See https://github.com/lotus/validations/issues/58
    it 'safely serialize to Hash' do
      data      = {name: 'John Smith', address: { line_one: '10 High Street' }}
      validator = NestedValidations.new(data)

      validator.to_h.must_equal(data)
    end

    # Bug
    # See https://github.com/lotus/validations/issues/58#issuecomment-99144243
    it 'safely serialize to Hash' do
      data      = {name: 'John Smith', tags: [1, 2]}
      validator = NestedValidations.new(data)

      validator.to_h.must_equal(data)
    end
  end
end
