module Hanami
  module Validations
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
        def validation_message_at(validation_name, on: nil, &block)
          attribute = on.nil? ? ValidationMessagesDictionary::DEFAULT_FLAG : on.to_sym
          validation_messages.at(validation_name, on: attribute, put: block)
        end

        def validation_messages
          @validation_messages ||= ValidationMessagesDictionary.new
        end
      end

      def validation_messages
        self.class.validation_messages
      end

      def validation_message_for(error)
        validation_messages.for error,
          if_none: proc{ ValidationMessagesLibrary.message_for(error) }
      end
    end
  end
end