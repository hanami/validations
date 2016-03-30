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
        @parameters_display_strings = Hash[]
      end

      # Defines the validation message for a validation type and optionally an attribute.
      #
      # @param validation_name [Symbol] the validation name
      # @param on [String] Optional - an attribute name
      # @param &block [Proc] the message block, which receives the validation error as its
      #        only parameter
      #
      # @since 0.x.0
      def at(validation_name, on: nil, &block)
        attribute = on.nil? ? DEFAULT_FLAG : on.to_sym
        @messages[validation_name][attribute] = block
      end

      def display(parameter, as:)
        @parameters_display_strings[parameter.to_sym] = as
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
        message_block.nil? ? if_none.call : message_block.call(error_to_display_on(error))
      end

      def display_string_for(error)
        @parameters_display_strings[error.attribute_name.to_sym]
      end

      def error_to_display_on(error)
        ErrorToDisplay.on error, display_string: display_string_for(error)
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