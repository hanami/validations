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

      # Sets or gets the validation mesage library
      #
      # @param  library  [Hanami::Validations::Messages::Library] Optiomal - the messages library
      #
      # @return [Hanami::Validations::Messages::Library] the global messages library
      #
      # @since 0.x.0
      def self.library(library = nil)
        @library = library unless library.nil?
        @library ||= Library.new
      end

      # Defines the default validation messages for each validation type
      # @param  &block  [Proc]  the configuration block
      #
      # @since 0.x.0
      def self.configure(&block)
        library.instance_eval(&block)
      end

      module ClassMethods
        # Answers the validation messages dictionary
        #
        # @param [Hanami::Validations::Messages::Dictionary] the validation messages dictionary
        #
        # @since 0.x.0
        # @api private
        def validation_messages(&block)
          (@validation_messages ||= Dictionary.new).tap do |messages|
            messages.instance_eval(&block) unless block.nil?
          end
        end
      end

      # Answers the validation messages dictionary
      #
      # @param [Hanami::Validations::Messages::Dictionary] the validation messages dictionary
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
        validation_messages.for error
      end
    end
  end
end