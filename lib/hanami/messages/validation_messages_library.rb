module Hanami
  module Validations
    # A global library of default validations messages for validation types
    #
    # @since 0.x.0
    module ValidationMessagesLibrary
      # Defines the validation messages for each validation type
      # @param  &block  [Proc]  the configuration block
      #
      # @since 0.x.0
      def self.configure(&block)
        self.instance_eval(&block)
      end

      # Defines a validation message block for a validation
      #
      # @param  validation_name  [Symbol]  the validation name
      # @param  &block  [Proc]  the message block, which takes the validation error as 
      #         its only parameter
      #
      # @since 0.x.0
      def self.message_at(validation_name, &block)
        messages[validation_name] = block
      end

      # Answers the validation message block for a validation
      #
      # @param  validation_name  [Symbol]  the validation name
      #
      # @return [Proc]  the message block, which takes the validation error as 
      #         its only parameter
      #
      # @since 0.x.0
      def self.message_block_for(validation_name)
        messages.fetch(validation_name)
      end

      # Answers the validation message block for a validation error
      #
      # @param  error  [Hanami::Validations::Error]  the validation error
      #
      # @return [Proc]  the message block, which takes the validation error as 
      #         its only parameter
      #
      # @since 0.x.0
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