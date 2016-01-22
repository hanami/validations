# FIXME Enable again after name switch off
#
# require 'test_helper'
# require 'hanami/utils'
# require 'hanami/model'

# describe 'Hanami::Entity compatibility' do
#   describe 'with attributes definition' do
#     before do
#       class Product
#         include Hanami::Entity
#         include Hanami::Validations

#         attribute :name,  type: String,  presence: true
#         attribute :price, type: Integer, presence: true
#       end

#       class ProductRepository
#         include Hanami::Repository
#       end

#       Hanami::Model.configure do
#         adapter type: :memory, uri: 'memory://localhost/test'

#         mapping do
#           collection :products do
#             entity     Product
#             repository ProductRepository

#             attribute :id,   Integer
#             attribute :name, String
#           end
#         end
#       end.load!
#     end

#     after do
#       Hanami::Model.unload!

#       Object.__send__(:remove_const, :Product)
#       Object.__send__(:remove_const, :ProductRepository)
#     end

#     it 'guarantees compatibility with entities' do
#       product = Product.new(name: 'foo')
#       product = ProductRepository.create(product)

#       product.id.wont_be_nil

#       found_product = ProductRepository.find(product.id)
#       assert product == found_product, "Expected product to equal found_product"

#       ProductRepository.delete(product)
#       ProductRepository.find(product.id).must_be_nil
#     end

#     it 'is able to validate' do
#       product = Product.new
#       product.wont_be :valid?
#     end

#     it 'coerces values' do
#       product = Product.new(price: '100')
#       product.price.must_equal 100
#     end
#   end

#   describe 'with only validations' do
#     before do
#       class Product
#         include Hanami::Entity
#         include Hanami::Validations

#         attributes :name, :price
#         validates  :name,  type: String,  presence: true
#         validates  :price, type: Integer, presence: true
#       end

#       class ProductRepository
#         include Hanami::Repository
#       end

#       Hanami::Model.configure do
#         adapter type: :memory, uri: 'memory://localhost/test'

#         mapping do
#           collection :products do
#             entity     Product
#             repository ProductRepository

#             attribute :id,   Integer
#             attribute :name, String
#           end
#         end
#       end.load!
#     end

#     after do
#       Hanami::Model.unload!

#       Object.__send__(:remove_const, :Product)
#       Object.__send__(:remove_const, :ProductRepository)
#     end

#     it 'guarantees compatibility' do
#       product = Product.new(name: 'foo')
#       product = ProductRepository.create(product)

#       product.id.wont_be_nil

#       found_product = ProductRepository.find(product.id)
#       assert product == found_product, "Expected product to equal found_product"

#       ProductRepository.delete(product)
#       ProductRepository.find(product.id).must_be_nil
#     end

#     it 'is able to validate' do
#       product = Product.new
#       product.wont_be :valid?
#     end

#     it 'coerces values' do
#       product = Product.new(price: '200')
#       product.price.must_equal 200
#     end

#     it '#to_h returns correct attributes' do
#       product = Product.new(name: 'hanami', price: '200')
#       product.to_h.must_equal({ id: nil, name: 'hanami', price: 200 })
#     end
#   end

#   describe 'with both attributes and validations' do
#     before do
#       class Product
#         include Hanami::Entity
#         include Hanami::Validations

#         attributes :name, :price
#         attribute  :name,  type: String,  presence: true
#         attribute  :price, type: Integer, presence: true
#       end

#       class ProductRepository
#         include Hanami::Repository
#       end

#       Hanami::Model.configure do
#         adapter type: :memory, uri: 'memory://localhost/test'

#         mapping do
#           collection :products do
#             entity     Product
#             repository ProductRepository

#             attribute :id,   Integer
#             attribute :name, String
#           end
#         end
#       end.load!
#     end

#     after do
#       Hanami::Model.unload!

#       Object.__send__(:remove_const, :Product)
#       Object.__send__(:remove_const, :ProductRepository)
#     end

#     it 'guarantees compatibility' do
#       product = Product.new(name: 'foo')
#       product = ProductRepository.create(product)

#       product.id.wont_be_nil

#       found_product = ProductRepository.find(product.id)
#       assert product == found_product, "Expected product to equal found_product"

#       ProductRepository.delete(product)
#       ProductRepository.find(product.id).must_be_nil
#     end

#     it 'is able to validate' do
#       product = Product.new
#       product.wont_be :valid?
#     end

#     it 'coerces values' do
#       product = Product.new(price: '300')
#       product.price.must_equal 300
#     end

#     it '#to_h returns correct attributes' do
#       product = Product.new(name: 'hanami', price: '200')
#       product.to_h.must_equal({ id: nil, name: 'hanami', price: 200 })
#     end
#   end
# end unless Hanami::Utils.jruby?
