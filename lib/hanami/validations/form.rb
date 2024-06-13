# frozen_string_literal: true

module Hanami
  module Validations
    # Validations mixin for forms/HTTP params.
    #
    # @since 0.6.0
    # @api private
    module Form
      # @since 2.0.0
      # @api private
      class BaseValidator < Dry::Validation::Contract
        unless Hanami.respond_to?(:env?) && Hanami.env?(:test)
          params do
            optional(:_csrf_token).filled(:string)
          end
        end
      end

      # @since 0.6.0
      # @api private
      def self.included(klass)
        super

        klass.class_eval do
          include ::Hanami::Validations
          extend ClassMethods
        end
      end

      # @since 0.6.0
      # @api private
      module ClassMethods
        # @since 2.0.0
        # @api private
        def validations(&blk)
          @_validator = Class.new(BaseValidator) { params(&blk) }.new
        end
      end
    end
  end
end
