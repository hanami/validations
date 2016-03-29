require 'test_helper'

describe Hanami::Validations::Messages do
  describe 'when the view overrides a message for a validation type' do
    let(:view) { OverrideValidationMessageTest.new }

    it 'uses the overriden message over the global default' do
      error = Hanami::Validations::Error.new(:street, :presence, true, 'Evergreen')

      view.validation_message_for(error).must_equal "street must be present"
    end
  end

  describe 'when the view overrides a message for a specific attribute validation' do
    let(:view) { OverrideValidationMessageTest.new }

    it 'uses the overriden message over the global default and the validation type' do
      error = Hanami::Validations::Error.new(:number, :presence, true, 'Evergreen')

      view.validation_message_for(error).must_equal "number must be defined"
    end
  end
end