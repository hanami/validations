require 'test_helper'

describe Lotus::Validations do
  describe "#initialie" do
    let(:val) { 'foo' }
    let(:attribute_name) { :name }
    let(:attributes) {{ name: val }}
    let(:errors) { Lotus::Validations::Errors.new }

    before do
      @validation = UserDefinedValidatorTest::IsFooValidator.new(
        attribute_name, attributes, errors
      )
    end

    describe "#value" do
      it "returns the value" do
        @validation.value.must_equal val
      end
    end

    describe "#attribute_name" do
      it "returns the attribute's name" do
        @validation.attribute_name.must_equal attribute_name
      end
    end

    describe "#errors" do
      it "returns the errors" do
        @validation.errors.must_equal errors
      end
    end

    describe "#default_validation_name" do
      it "returns a default name based on the validator's name" do
        @validation.default_validation_name.must_equal :is_foo
      end
    end

    describe "#add_error" do
      let(:expected) { 'baz' }
      let(:validation_name) { :my_validation }
      let(:namespace) { 'foo' }
      let(:options) {{
        expected: expected,
        validation_name: validation_name,
        namespace: namespace
      }}

      before do
        @validation.add_error(options)
        @error = errors.for(:name).first
      end

      it "adds an error to the errors" do
        errors.for(:name).must_be :any?
      end

      describe "error" do
        it "is an errror" do
          @error.must_be_instance_of Lotus::Validations::Error
        end

        describe "#actual" do
          it "returns the value" do
            @error.actual.must_equal val
          end
        end

        describe "#attribute" do
          it "returns the attribute_name prefixed with the namespace" do
            @error.attribute.must_equal "#{namespace}.#{attribute_name}"
          end
        end

        describe "#expected" do
          it "returns the expected value" do
            @error.expected.must_equal expected
          end
        end

        describe "#validation" do
          it "reuturns the validation name" do
            @error.validation.must_equal validation_name
          end
        end
      end
    end
  end

  describe "#call with valid value" do
    let(:val) { 'foo' }
    let(:attribute_name) { :foo }
    let(:attributes) {{ foo: val }}
    let(:errors) { Lotus::Validations::Errors.new }

    before do
      @validation = UserDefinedValidatorTest::IsFooValidator.new(
        attribute_name, attributes, errors
      )
      @validation.call(val)
    end

    it "doesn't add an error" do
      errors.must_be :empty?
    end
  end

  describe "#call with invalid value" do
    let(:val) { 'fool' }
    let(:attribute_name) { :foo }
    let(:attributes) {{ foo: val }}
    let(:errors) { Lotus::Validations::Errors.new }

    before do
      @validation = UserDefinedValidatorTest::IsFooValidator.new(
        attribute_name, attributes, errors
      )
      @validation.call(val)
    end

    it "adds an error" do
      errors.wont_be :empty?
    end
  end

  describe "explicit validation name" do
    let(:val) { 'fool' }
    let(:attribute_name) { :foo }
    let(:attributes) {{ foo: val }}
    let(:errors) { Lotus::Validations::Errors.new }

    before do
      @validation = ExplicitValidationNameTest::IsFooValidator.new(
        attribute_name, attributes, errors
      )
      @validation.call(val)
      @error = errors.for(:foo).first
    end

    it "adds an error" do
      errors.wont_be :empty?
    end

    describe "error" do
      describe "#validation" do
        it "returns the expected name" do
          @error.validation.must_equal :custom_validation
        end
      end
    end
  end
end
