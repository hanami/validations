require 'hanami/validations'

module Hanami
  module Validations
    module Form
      # Override Ruby's hook for modules.
      #
      # @param base [Class] the target action
      #
      # @since 0.1.0
      # @api private
      #
      # @see http://www.ruby-doc.org/core/Module.html#method-i-included
      def self.included(base)
        base.class_eval do
          include Validations
          extend  ClassMethods
        end
      end

      module ClassMethods
        private

        def _schema_type
          :Form
        end

        def _schema_config
          lambda do |config|
          end
        end
      end
    end
  end
end
