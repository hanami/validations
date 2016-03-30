module Hanami
  module Validations
    module Messages
      # A library of validation messages for validation types
      #
      # @since 0.x.0
      class Library
        # Defines a validation message block for a validation
        #
        # @param  validation_name  [Symbol]  the validation name
        # @param  &block  [Proc]  the message block, which takes the validation error as 
        #         its only parameter
        #
        # @since 0.x.0
        def message_at(validation_name, &block)
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
        def message_block_for(validation_name)
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
        def message_for(error)
          message_block_for(error.validation).call(error)
        end

        protected

        def messages
          @messages ||= Hash[]
        end
      end
    end
  end
end