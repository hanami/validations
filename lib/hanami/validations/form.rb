require 'hanami/validations'

module Hanami
  class Validations
    # Validations mixin for forms/HTTP params.
    #
    # This must be used when the input comes from a browser or an HTTP endpoint.
    # It knows how to deal with common data types, and common edge cases like blank strings.
    #
    # @since 0.6.0
    #
    # @example
    #   require 'hanami/validations/form'
    #
    #   class Signup < Hanami::Validations::Form
    #
    #     validations do
    #       required(:name).filled(:str?)
    #       optional(:location).filled(:str?)
    #     end
    #   end
    #
    #   result = Signup.new('location' => 'Rome').validate
    #   result.success? # => false
    #
    #   result = Signup.new('name' => 'Luca').validate
    #   result.success? # => true
    #
    #   # it works with symbol keys too
    #   result = Signup.new(location: 'Rome').validate
    #   result.success? # => false
    #
    #   result = Signup.new(name: 'Luca').validate
    #   result.success? # => true
    #
    #   result = Signup.new(name: 'Luca', location: 'Rome').validate
    #   result.success? # => true
    class Form < Validations
      # @param base [Class] the target action
      #
      # @since 0.6.0
      # @api private
      class << self
        private

        # @since 0.6.0
        # @api private
        def _schema_type
          :Form
        end
      end
    end
  end
end
