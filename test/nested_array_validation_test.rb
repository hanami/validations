require 'test_helper'

describe Lotus::Validations do

  describe 'nested attributes' do
    before do
      @validable = NestedArrayWithCoercion.new(
        name: 'Parent Class',
        nested: [{
          name: 'Nested Class'
        }]
      )
    end

    it 'sets parent attributes' do
      @validable.name.must_equal 'Parent Class'
    end

    it 'sets nested array' do
      @validable.nested.must_be_kind_of Array
      @validable.nested.size.must_equal 1
    end

    it 'has coerced nested attribute' do
      @validable.nested.all?{|n| n.must_be_kind_of NestedValidations }
    end
  end

  describe 'nested validations' do
    describe 'nested object validations pass' do
      before do
        @validable = NestedArrayWithCoercion.new(
          name: 'Parent Class',
          nested: [{
            name: 'Nested Class'
          }]
        )
      end

      it 'is valid' do
        @validable.valid?.must_equal true
      end
    end

    describe 'nested object validations fail' do
      before do
        @validable = NestedArrayWithCoercion.new(
          name: 'Parent Class',
          nested: [
            {
              name: nil
            },
            {
              name: "Valid Name"
            },
            {
              name: nil
            }
          ]
        )
      end

      it 'is invalid' do
        @validable.valid?.must_equal false
      end

      it 'collects errors for nested attributes' do
        @validable.valid?
        @validable.errors.to_a.must_equal [
          Lotus::Validations::Error.new(:name, :presence, true, nil, 'nested[0]'),
          Lotus::Validations::Error.new(:name, :presence, true, nil, 'nested[2]')
        ]
      end
    end
  end
end
