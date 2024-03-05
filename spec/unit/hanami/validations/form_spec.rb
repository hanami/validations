# frozen_string_literal: true

RSpec.describe Hanami::Validations::Form do
  before do
    $LOADED_FEATURES.delete_if { |f| f.end_with?("lib/hanami/validations/form.rb") }

    # FIXME: remove the following two lines
    present = !$LOADED_FEATURES.find { |f| f.end_with?("lib/hanami/validations/form.rb") }
    expect(present).to be(false)
  end

  subject do
    form = described_class

    Class.new do
      include form

      validations do
        required(:name).value(:string)
      end
    end._validator
  end

  it "includes base validation rules" do
    result = subject.call({})

    expect(result).to_not be_success
    expect(result.errors.to_h).to include({name: ["is missing"]})

    result = subject.call(name: "Luca")

    expect(result).to be_success
    expect(result.errors).to be_empty
  end

  context "CSRF Token" do
    it "validates the token" do
      result = subject.call(_csrf_token: "")

      expect(result).to_not be_success
      expect(result.errors.to_h).to include({_csrf_token: ["must be filled"]})
    end

    context "when Hanami env is test" do
      before do
        allow(Hanami).to receive(:env?).with(:test).and_return(true)
      end

      it "ignores invalid token" do
        result = subject.call(_csrf_token: "")

        expect(result).to be_success
        expect(result.errors).to be_empty
      end
    end
  end
end
