module Hanami
  module Validations
    # A mixin to access and override validation error messages
    #
    # @since 0.x.0
    module Messages
      # Override Ruby's hook for modules.
      #
      # @param base [Class] the target action
      #
      # @since 0.x.0
      # @api private
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods
        # Defines the validation message for a validation type and optionally an attribute.
        #
        # @param validation_name [Symbol] the validation name
        # @param on [String] Optional - an attribute name
        # @param &block [Proc] the message block, which receives the validation error as its
        #        only parameter
        #
        # @since 0.x.0
        def validation_message_at(validation_name, on: nil, &block)
          attribute = on.nil? ? ValidationMessagesDictionary::DEFAULT_FLAG : on.to_sym
          validation_messages.at(validation_name, on: attribute, put: block)
        end

        # Answers the validation messages dictionary
        #
        # @param [Hanami::Validations::ValidationMessagesDictionary] the validation messages dictionary
        #
        # @since 0.x.0
        # @api private
        def validation_messages
          @validation_messages ||= ValidationMessagesDictionary.new
        end
      end

      # Answers the validation messages dictionary
      #
      # @param [Hanami::Validations::ValidationMessagesDictionary] the validation messages dictionary
      #
      # @since 0.x.0
      # @api private
      def validation_messages
        self.class.validation_messages
      end

      # Answers the validation message for an error
      #
      # @param error [Hanami::Validations::Error] the validation error
      #
      # @return [String] the validation error message
      #
      # @since 0.x.0
      # @api private
      def validation_message_for(error)
        validation_messages.for error,
          if_none: proc{ ValidationMessagesLibrary.message_for(error) }
      end
    end
  end
end