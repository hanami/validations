require 'lotus/utils/kernel'

module Lotus
  module Validations
    class AttributeValidator
      def initialize(validator, name, options)
        @validator, @name, @options = validator, name, options
        @value = @validator.__send__(@name)
      end

      def validate!
        presence
        _run_validations
      end

      private
      def presence
        _validate(__method__) { !skip? }
      end

      def format
        _validate(__method__) {|matcher| @value.to_s.match(matcher) }
      end

      def inclusion
        _validate(__method__) {|collection| collection.include?(@value) }
      end

      def coerce
        _validate(:type) do |coercer|
          @value = Lotus::Utils::Kernel.send(coercer.to_s, @value)
          @validator.attributes[@name] = @value
        end
      end

      def skip?
        @value.nil?
      end

      def _run_validations
        return if skip?

        format
        coerce
        inclusion
      end

      def _validate(validation)
        if (validator = @options[validation]) && !(yield validator)
          @validator.errors[@name].push(validation)
        end
      end

    end
  end
end
