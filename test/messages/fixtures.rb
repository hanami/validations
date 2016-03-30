class DefaultMessagesTest
  include Hanami::Validations::Messages
end

class OverrideValidationMessageTest
  include Hanami::Validations::Messages

  validation_messages do
    at :presence do |error|
      "#{error.attribute_name} must be present"
    end

    at :presence, on: 'number' do |error|
      "#{error.attribute_name} must be defined"
    end
  end
end

class OverrideAttributeNameTest
  include Hanami::Validations::Messages

  validation_messages do
    display :street, as: 'Street'

    at :presence do |error|
      "#{error.attribute_name} must be present"
    end
  end
end

class OverrideLibraryTest
  include Hanami::Validations::Messages

  def self.custom_library
    Hanami::Validations::Messages::Library.new.tap do |library|
      library.message_at(:presence) do |error|
        "The field #{error.attribute_name} is mandatory"
      end
    end
  end

  validation_messages do
    use_library OverrideLibraryTest.custom_library
  end
end