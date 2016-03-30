module Hanami
  module Validations
    module Messages
      class ErrorToDisplay
        def self.on(validation_error, display_string: nil)
          self.new(validation_error, display_string: display_string)
        end

        def initialize(validation_error, display_string: nil)
          @validation_error = validation_error
          @attribute_display_string = display_string
        end

        def attribute_name
          no_attribute_display_string? ? @validation_error.attribute_name : @attribute_display_string
        end

        def method_missing(method_name, *args, &block)
          @validation_error.send(method_name, *args, &block)
        end

        def no_attribute_display_string?()
          @attribute_display_string.nil?
        end
      end
    end
  end
end