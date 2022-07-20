# frozen_string_literal: true

RSpec.describe "Hanami::Validations::VERSION" do
  it "exposes version" do
    expect(Hanami::Validations::VERSION).to eq("1.3.9")
  end
end
