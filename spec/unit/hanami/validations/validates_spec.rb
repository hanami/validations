# frozen_string_literal: true
RSpec.describe Hanami::Validations do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validations do
        required(:name) { filled? }
      end
    end
  end

  it "returns successful validation result for valid data" do
    result = @validator.new(name: "Luca").validate

    expect(result).to be_success
    expect(result.errors).to be_empty
  end

  it "returns failing validation result for invalid data" do
    result = @validator.new({}).validate

    expect(result).not_to be_success
    expect(result.messages.fetch(:name)).to eq ["is missing"]
  end
end
