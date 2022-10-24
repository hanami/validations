# frozen_string_literal: true

RSpec.describe "Hanami::Validations::VERSION" do
  it "returns current version" do
    expect(Hanami::Validations::VERSION).to eq("2.0.0.beta4")
  end
end
