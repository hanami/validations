require 'test_helper'

describe Hanami::Validations do
  describe 'composable' do
    describe 'without extra validations' do
      it 'is not valid if included attributes are not valid' do
        validator = ComposedValidationsTest.new({})

        validator.valid?.must_equal false
      end

      it 'is valid if included attributes are valid' do
        validator = ComposedValidationsTest.new(email: '@')

        validator.valid?.must_equal true
      end
    end

    describe 'with extra validations' do
      it 'is not valid if no attributes are valid' do
        validator = ComposedValidationsWithExtraAttributesTest.new({})

        validator.valid?.must_equal false
        errors = validator.errors
        errors.for(:name).wont_be_empty
        errors.for(:email).wont_be_empty
      end

      it 'is not valid if included attributes are not valid' do
        validator = ComposedValidationsWithExtraAttributesTest.new(name: 'L')

        validator.valid?.must_equal false
        errors = validator.errors
        errors.for(:name).must_be_empty
        errors.for(:email).wont_be_empty
      end

      it 'is valid if all attributes are valid' do
        validator = ComposedValidationsWithExtraAttributesTest.new(name: 'L', email: '@')

        validator.valid?.must_equal true
      end

      # Bug https://github.com/hanami/validations/issues/81
      it 'is valid if included attributes are blank and does not define presence constraint' do
        validator = ComposedValidationsWithoutPresenceTest.new(email: '', name: '')

        validator.valid?.must_equal true
      end

      it 'is not valid if included attributes are invalid' do
        validator = ComposedValidationsWithoutPresenceTest.new(email: 'fo', name: 'o')

        validator.valid?.must_equal false
      end
    end

    describe 'nested composed validations' do
      it 'is not valid if included attributes are not valid' do
        validator = NestedComposedValidationsTest.new({})

        validator.valid?.must_equal false
      end

      it 'is valid if included attributes are valid' do
        validator = NestedComposedValidationsTest.new(email: '@')

        validator.valid?.must_equal true
      end
    end

    describe 'decorated composed validations' do
      it 'inherits composed validation' do
        validator = DecoratedValidations.new(password: nil)
        validator.valid?.must_equal false

        error = validator.errors.for(:password).first
        error.validation.must_equal(:presence)
      end

      it "validates with the decorated rule" do
        validator = DecoratedValidations.new(password: 'secret', password_confirmation: 'ops!')

        validator.valid?.must_equal false

        error = validator.errors.for(:password).first
        error.validation.must_equal(:confirmation)
      end

      it "the original validator keeps the defined rules" do
        validator = UndecoratedValidations.new(password: nil)

        validator.valid?.must_equal false

        error = validator.errors.for(:password).first
        error.validation.must_equal(:presence)
      end

      it "the decorated rules don't interfer with the original one" do
        validator = UndecoratedValidations.new(password: 'secret', password_confirmation: '123')

        validator.valid?.must_equal true
      end
    end
  end
end
