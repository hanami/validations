require 'test_helper'

describe Lotus::Validations do
  describe 'nested attributes' do
    before do
      @klass = Class.new do
        include Lotus::Validations

        attribute :name, type: String
        attribute :address do
          attribute :line_one, type: String, presence: true
          attribute :city, type: String
          attribute :country, type: String
          attribute :post_code, type: String
        end
      end
    end

    it 'builds nested attributes' do
      validator = @klass.new(name: 'John Smith', address: { line_one: '10 High Street' })
      validator.address.line_one.must_equal('10 High Street')
      validator.name.must_equal('John Smith')
    end

    it 'responds with an empty class on nil' do
      @klass.new({}).address.line_one.must_be_nil
    end

    it 'is invalid when nested attributes fail validation' do
      validator = @klass.new(name: 'John Smith', address: { city: 'Melbourne' })
      validator.valid?.must_equal(false)
      expected_error = Lotus::Validations::Error.new('address.line_one', :presence, true, nil)
      line_one_errors = validator.errors.for('address.line_one')
      line_one_errors.must_include(expected_error)
      validator.errors.to_h.must_equal({
        'address.line_one' => [Lotus::Validations::Error.new('address.line_one', :presence, true, nil)]
      })
    end

    it 'is valid when nested attributes pass validation' do
      validator = @klass.new(name: 'John Smith', address: { line_one: '10 High Street' })
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
      validator = @klass.new(data)

      validator.to_h.must_equal(data)
    end
  end
end
