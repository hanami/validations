require 'hanami/validations/attribute'

module Hanami
  module Validations
    class ArrayAttribute < Attribute

      # Validates nested Array of Hanami Validations objects
      #
      # @since 0.3.3
      # @api private
      def nested
        _validate(__method__) do |validator|
          value.each_with_index do |member, i|
            errors = member.validate
            errors.each do |error|
              new_error = Error.new(error.attribute, error.validation, error.expected, error.actual, "#{@name}[#{i}]")
              @errors.add new_error.attribute, new_error
            end
            true
          end
        end
      end
    end
  end
end
