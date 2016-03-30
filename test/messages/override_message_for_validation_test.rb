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

  describe 'when the view overrides an attribute name' do
    let(:view) { OverrideAttributeNameTest.new }

    it 'uses the overriden attribute name' do
      error = Hanami::Validations::Error.new(:street, :presence, true, 'Evergreen')

      view.validation_message_for(error).must_equal "Street must be present"
    end
  end

  describe 'when the view changes the message library' do
    let(:view) { OverrideLibraryTest.new }

    it 'uses the overriden library only in the context of a dictionary' do
      error = Hanami::Validations::Error.new(:street, :presence, true, 'Evergreen')

      view.validation_message_for(error).must_equal "The field street is mandatory"
      error.to_s.must_equal "can not be left blank"
    end
  end
end