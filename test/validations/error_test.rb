require 'test_helper'

describe Lotus::Validations::Error do
  describe "#to_s" do
    describe "acceptance" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(
          attribute_name: :terms_of_service,
          validation: :acceptance,
          expected: true).to_s
        message.must_equal "Terms of service must be accepted"
      end
    end

    describe "confirmation" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(
          attribute_name: :password,
          validation: :confirmation,
          expected: true,
          actual: 'notmatching').to_s
        message.must_equal "Password doesn't match"
      end
    end

    describe "exclusion" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(
          attribute_name: :music,
          validation: :exclusion,
          expected: ['pop', 'dance'],
          actual: 'pop').to_s
        message.must_equal "Music shouldn't belong to pop, dance"
      end
    end

    describe "format" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(
          attribute_name: :email,
          validation: :format,
          expected: /\A(.*)\@(.*)\.(.*)\z/,
          actual: 'foo').to_s
        message.must_equal "Email doesn't match expected format"
      end
    end

    describe "inclusion" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(
          attribute_name: :age,
          validation: :inclusion,
          expected: 18..99,
          actual: 17).to_s
        message.must_equal "Age isn't included"
      end
    end

    describe "presence" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(
          attribute_name: :name,
          validation: :presence,
          expected: true,
          actual: '').to_s
        message.must_equal "Name must be present"
      end
    end

    describe "size" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(
          attribute_name: :ssn,
          validation: :size,
          expected: 11,
          actual: '234').to_s
        message.must_equal "Ssn doesn't match expected size"
      end
    end
  end
end
