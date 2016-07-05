require 'hanami/validations'

module Hanami
  module Validations
    # Validations mixin for forms/HTTP params.
    #
    # This must be used when the input comes from a browser or an HTTP endpoint.
    # It knows how to deal with common data types, and common edge cases like blank strings.
    #
    # @since x.x.x
    #
    # @example
    #   require 'hanami/validations/form'
    #
    #   class Signup
    #     include Hanami::Validations::Form
    #   end
    module Form
      # Override Ruby's hook for modules.
      #
      # @param base [Class] the target action
      #
      # @since x.x.x
      # @api private
      #
      # @see http://www.ruby-doc.org/core/Module.html#method-i-included
      def self.included(base)
        base.class_eval do
          include Validations
          extend  ClassMethods
        end
      end

      # @since x.x.x
      # @api private
      module ClassMethods
        private

        # @since x.x.x
        # @api private
        def _schema_type
          :Form
        end
      end
    end
  end
end
