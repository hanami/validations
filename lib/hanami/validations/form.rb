# frozen_string_literal: true

module Hanami
  module Validations
    # Validations mixin for forms/HTTP params.
    #
    # This must be used when the input comes from a browser or an HTTP endpoint.
    # It knows how to deal with common data types, and common edge cases like blank strings.
    #
    # @since 0.6.0
    #
    # @example
    #   require "hanami/validations/form"
    #
    #   class Signup
    #     include Hanami::Validations::Form
    #
    #     validations do
    #       required(:name).value(:string)
    #       optional(:location).value(:string)
    #     end
    #   end
    #
    #   result = Signup.new("location" => "Rome").validate
    #   result.success? # => false
    #
    #   result = Signup.new("name" => "Luca").validate
    #   result.success? # => true
    #
    #   # it works with symbol keys too
    #   result = Signup.new(location: "Rome").validate
    #   result.success? # => false
    #
    #   result = Signup.new(name: "Luca").validate
    #   result.success? # => true
    #
    #   result = Signup.new(name: "Luca", location: "Rome").validate
    #   result.success? # => true
    module Form
      # @since 2.0.0
      # @api private
      class BaseValidator < Dry::Validation::Contract
        params do
          optional(:_csrf_token).filled(:str?)
        end
      end

      # Override Ruby's hook for modules.
      #
      # @param klass [Class] the target action
      #
      # @since 0.6.0
      # @api private
      #
      # @see http://www.ruby-doc.org/core/Module.html#method-i-included
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
