class DefaultMessagesTest
	include Hanami::Validations::Messages
end

class OverrideValidationMessageTest
	include Hanami::Validations::Messages

	validation_message_at :presence do |error|
		"#{error.attribute_name} must be present"
	end

	validation_message_at :presence, on: 'number' do |error|
		"#{error.attribute_name} must be defined"
	end
end