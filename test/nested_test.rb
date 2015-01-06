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
  end
end
