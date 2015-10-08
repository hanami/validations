require 'test_helper'

describe Lotus::Validations::Error do
  describe "#to_s" do
    describe "acceptance" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(:terms_of_service, :acceptance, true, nil, nil).to_s
        message.must_equal "Terms of service must be accepted"
      end
    end

    describe "confirmation" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(:password, :confirmation, true, 'notmatching', nil).to_s
        message.must_equal "Password doesn't match"
      end
    end

    describe "exclusion" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(:music, :exclusion, ['pop', 'dance'], 'pop', nil).to_s
        message.must_equal "Music shouldn't belong to pop, dance"
      end
    end

    describe "format" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(:email, :format, /\A(.*)\@(.*)\.(.*)\z/, 'foo', nil).to_s
        message.must_equal "Email doesn't match expected format"
      end
    end

    describe "inclusion" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(:age, :inclusion, 18..99, 17, nil).to_s
        message.must_equal "Age isn't included"
      end
    end

    describe "presence" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(:name, :presence, true, '', nil).to_s
        message.must_equal "Name must be present"
      end
    end

    describe "size" do
      it "returns standard message" do
        message = Lotus::Validations::Error.new(:ssn, :size, 11, '234', nil).to_s
        message.must_equal "Ssn doesn't match expected size"
      end
    end
  end
end
