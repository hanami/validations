module Hanami
  module Validations
    class ValidationMessagesDictionary
      DEFAULT_FLAG = Object.new.freeze

      def initialize
        @messages = Hash.new { |hash, key| hash[key] = Hash[] }
      end

      def at(validation_name, on:, put:)
        @messages[validation_name][on] = put
      end

      def for(error, if_none:)
        return if_none.call unless includes_validation?(error.validation)

        message_block_for(error).call(error)
      end

      def message_block_for(error)
        message_for_validation(error.validation, attribute: error.attribute_name)
      end

      def includes_validation?(validation)
        @messages.key?(validation)
      end

      def message_for_validation(validation, attribute:)
        @messages[validation][attribute.to_sym] || @messages[validation][DEFAULT_FLAG]
      end
    end
  end
end