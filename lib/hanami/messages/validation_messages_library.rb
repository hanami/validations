module Hanami
  module Validations
    module ValidationMessagesLibrary
      def self.configure(&block)
        self.instance_eval(&block)
      end

      def self.message_at(validation_name, &block)
        messages[validation_name] = block
      end

      def self.message_block_for(validation_name)
        messages.fetch(validation_name)
      end

      def self.message_for(error)
        message_block_for(error.validation).call(error)
      end

      protected

      def self.messages
        @messages ||= Hash[]
      end
    end
  end
end