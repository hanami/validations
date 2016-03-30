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
        # Answers the validation messages dictionary
        #
        # @param [Hanami::Validations::ValidationMessagesDictionary] the validation messages dictionary
        #
        # @since 0.x.0
        # @api private
        def validation_messages(&block)
          (@validation_messages ||= ValidationMessagesDictionary.new).tap do |messages|
            messages.instance_eval(&block) unless block.nil?
          end
        end
      end

      # Answers the validation messages dictionary
      #
      # @param [Hanami::Validations::ValidationMessagesDictionary] the validation messages dictionary
      #
      # @since 0.x.0
      # @api private
      def validation_messages(&block)
        self.class.validation_messages(&block)
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