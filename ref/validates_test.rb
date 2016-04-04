require 'test_helper'

describe Hanami::Validations, 'standalone' do
  before do
    @validator_class = Class.new do
      include Hanami::Validations

      def initialize(attributes = {})
        @name = attributes.fetch(:name)
      end

      attr_accessor :name

      validates :name, presence: true
    end
  end

  it "can validate without having defining the attribute" do
    validator = @validator_class.new(name: '')
    validator.valid?.must_equal false
    validator.name = 'Luca'
    validator.valid?.must_equal true

    another_validator = @validator_class.new(name: '')
    another_validator.invalid?.must_equal true
    another_validator.name = 'Luca'
    another_validator.invalid?.must_equal false
  end
end
