module Hanami
  module Validations
    # A dictionary of validation messages
    #
    # @since 0.x.0
    # @api private
    class ValidationMessagesDictionary
      # A flag for the default message of a given validation type
      #
      # @since 0.x.0
      # @api private
      DEFAULT_FLAG = Object.new.freeze

      def initialize
        @messages = Hash.new { |hash, key| hash[key] = Hash[] }
      end

      # Sets the message block for a given validation name and attribute 
      #
      # @params validation_name  [Symbol] the validation name
      # @params on  [String] the attribute name
      # @params put [Proc] the message block
      #
      # @since 0.x.0
      def at(validation_name, on:, put:)
        @messages[validation_name][on] = put
      end

      # Answers the validation message for an error
      #
      # @params error  [Hanami::Validations::Error] the validation error
      # @params if_none [Proc] a block to execute when there is not validation message for
      #         that error
      #
      # @return [String|Object] the validation error message or the result of the if_none block
      #
      # @since 0.x.0
      def for(error, if_none:)
        message_block = message_block_for(error)
        message_block.nil? ? if_none.call : message_block.call(error)
      end

      protected

      # Answers the validation message block for an error
      #
      # @params error  [Hanami::Validations::Error] the validation error
      #
      # @return [Proc|nil] the validation error message block or nil
      #
      # @since 0.x.0
      # @api private
      def message_block_for(error)
        message_block_for_validation(error.validation, attribute: error.attribute_name)
      end

      # Answers the validation message block for a validation and an attribute name
      #
      # @params validation  [Symbol] the validation name
      # @params attribute  [String] the attribute name
      #
      # @return [Proc|nil] the validation error message block or nil
      #
      # @since 0.x.0
      # @api private
      def message_block_for_validation(validation, attribute:)
        @messages
          .fetch(validation, Hash[])
          .fetch(attribute.to_sym, default_message_for_validation(validation))
      end

      # Answers the default validation message block for a validation type
      #
      # @params validation  [Symbol] the validation name
      #
      # @return [Proc|nil] the validation error message block or nil
      #
      # @since 0.x.0
      # @api private
      def default_message_for_validation(validation)
        @messages.fetch(validation, Hash[])[DEFAULT_FLAG]
      end
    end
  end
end