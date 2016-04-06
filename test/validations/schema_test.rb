require 'test_helper'
require 'hanami/validations/rules'
require 'hanami/validations/schema'

describe Hanami::Validations::Schema do
  describe '#add' do
    it 'accepts a set of rules' do
      rules  = Hanami::Validations::Rules.new(:foo, -> { true })
      schema = Hanami::Validations::Schema.new
      schema.add rules

      schema.rules.must_equal [rules]
    end
  end

  describe '#call' do
    it 'validates data based on given rules' do
      first_name = Hanami::Validations::Rules.new(:first_name, -> { presence? })
      last_name  = Hanami::Validations::Rules.new(:last_name,  -> { presence? })

      schema = Hanami::Validations::Schema.new
      schema.add first_name
      schema.add last_name

      result = schema.call({})
      result.wont_be :success?
      result.errors.keys.must_equal [:first_name, :last_name]
      result.errors.fetch(:first_name).must_equal [Hanami::Validations::Rules::Error.new(:first_name, :presence?, nil, nil)]
      result.errors.fetch(:last_name).must_equal  [Hanami::Validations::Rules::Error.new(:last_name, :presence?, nil, nil)]
    end

    it 'validates data based on nested rules' do
      city    = Hanami::Validations::Rules.new(:city, -> { presence? })
      address = Hanami::Validations::Schema.new(:address)
      address.add city

      schema = Hanami::Validations::Schema.new
      schema.add address

      result = schema.call({})
      result.wont_be :success?
      result.errors.keys.must_equal [:'address.city']
      result.errors.fetch(:'address.city').must_equal [Hanami::Validations::Rules::Error.new(:'address.city', :presence?, nil, nil)]
    end

    it 'validates data based on deep nested rules' do
      country = Hanami::Validations::Rules.new(:country, -> { presence? })
      address = Hanami::Validations::Schema.new(:address)
      address.add country

      customer = Hanami::Validations::Schema.new(:customer)
      customer.add address

      schema = Hanami::Validations::Schema.new
      schema.add customer

      result = schema.call({})
      result.wont_be :success?
      result.errors.keys.must_equal [:'customer.address.country']
      result.errors.fetch(:'customer.address.country').must_equal [Hanami::Validations::Rules::Error.new(:'customer.address.country', :presence?, nil, nil)]
    end
  end
end
