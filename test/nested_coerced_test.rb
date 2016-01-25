require 'test_helper'

describe Hanami::Validations do

  describe 'nested attributes' do
    before do
      @validable = NestedWithCoercion.new(
        name: 'Parent Class',
        nested: {
          name: 'Nested Class'
        }
      )
    end

    it 'sets parent attributes' do
      @validable.name.must_equal 'Parent Class'
    end

    it 'sets nested attributes' do
      @validable.nested.name.must_equal 'Nested Class'
    end

    it 'has coerced nested attribute' do
      @validable.nested.must_be_kind_of NestedValidations
    end
  end

  describe 'nested validations' do
    it 'is valid when nested object validations pass' do
      validable = NestedWithCoercion.new(name: 'Parent Class', nested: { name: 'Nested Class' })
      validable.valid?.must_equal true
    end

    describe 'nested validations fail' do
      before do
        @validable = NestedWithCoercion.new(
          name: 'Parent Class',
          nested: {
            name: nil
          }
        )
      end

      it 'is invalid' do
        @validable.valid?.must_equal false
      end

      it 'collects errors for nested attribute' do
        @validable.valid?
        errors = @validable.errors.for('nested.name')
        errors.wont_be_empty
        errors.must_include Hanami::Validations::Error.new(:name, :presence, true, nil, :nested)
      end

    end
  end

end
