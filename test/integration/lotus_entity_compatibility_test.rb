require 'test_helper'
require 'lotus/utils'
require 'lotus/model'

describe 'Lotus::Entity compatibility' do
  describe 'with attributes definition' do
    before do
      class Product
        include Lotus::Entity
        include Lotus::Validations

        attribute :name,  type: String,  presence: true
        attribute :price, type: Integer, presence: true
      end

      class ProductRepository
        include Lotus::Repository
      end

      Lotus::Model.configure do
        adapter type: :memory, uri: 'memory://localhost/test'

        mapping do
          collection :products do
            entity     Product
            repository ProductRepository

            attribute :id,   Integer
            attribute :name, String
          end
        end
      end.load!
    end

    after do
      Lotus::Model.unload!

      Object.__send__(:remove_const, :Product)
      Object.__send__(:remove_const, :ProductRepository)
    end

    it 'guarantees compatibility with entities' do
      product = Product.new(name: 'foo')
      product = ProductRepository.create(product)

      product.id.wont_be_nil

      found_product = ProductRepository.find(product.id)
      assert product == found_product, "Expected product to equal found_product"

      ProductRepository.delete(product)
      ProductRepository.find(product.id).must_be_nil
    end

    it 'is able to validate' do
      product = Product.new
      product.wont_be :valid?
    end

    it 'coerces values' do
      product = Product.new(price: '100')
      product.price.must_equal 100
    end
  end

  describe 'with only validations' do
    before do
      class Product
        include Lotus::Entity
        include Lotus::Validations

        attributes :name, :price
        validates  :name,  type: String,  presence: true
        validates  :price, type: Integer, presence: true
      end

      class ProductRepository
        include Lotus::Repository
      end

      Lotus::Model.configure do
        adapter type: :memory, uri: 'memory://localhost/test'

        mapping do
          collection :products do
            entity     Product
            repository ProductRepository

            attribute :id,   Integer
            attribute :name, String
          end
        end
      end.load!
    end

    after do
      Lotus::Model.unload!

      Object.__send__(:remove_const, :Product)
      Object.__send__(:remove_const, :ProductRepository)
    end

    it 'guarantees compatibility' do
      product = Product.new(name: 'foo')
      product = ProductRepository.create(product)

      product.id.wont_be_nil

      found_product = ProductRepository.find(product.id)
      assert product == found_product, "Expected product to equal found_product"

      ProductRepository.delete(product)
      ProductRepository.find(product.id).must_be_nil
    end

    it 'is able to validate' do
      product = Product.new
      product.wont_be :valid?
    end

    it 'coerces values' do
      product = Product.new(price: '200')
      product.price.must_equal 200
    end
  end

  describe 'with both attributes and validations' do
    before do
      class Product
        include Lotus::Entity
        include Lotus::Validations

        attributes :name, :price
        attribute  :name,  type: String,  presence: true
        attribute  :price, type: Integer, presence: true
      end

      class ProductRepository
        include Lotus::Repository
      end

      Lotus::Model.configure do
        adapter type: :memory, uri: 'memory://localhost/test'

        mapping do
          collection :products do
            entity     Product
            repository ProductRepository

            attribute :id,   Integer
            attribute :name, String
          end
        end
      end.load!
    end

    after do
      Lotus::Model.unload!

      Object.__send__(:remove_const, :Product)
      Object.__send__(:remove_const, :ProductRepository)
    end

    it 'guarantees compatibility' do
      product = Product.new(name: 'foo')
      product = ProductRepository.create(product)

      product.id.wont_be_nil

      found_product = ProductRepository.find(product.id)
      assert product == found_product, "Expected product to equal found_product"

      ProductRepository.delete(product)
      ProductRepository.find(product.id).must_be_nil
    end

    it 'is able to validate' do
      product = Product.new
      product.wont_be :valid?
    end

    it 'coerces values' do
      product = Product.new(price: '300')
      product.price.must_equal 300
    end
  end
end unless Lotus::Utils.jruby?
