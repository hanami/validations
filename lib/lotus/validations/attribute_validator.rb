require 'lotus/utils/kernel'

module Lotus
  module Validations
    class AttributeValidator
      def initialize(validator, name, options)
        @validator, @name, @options = validator, name, options

        @errors = @validator.errors
        @value  = @validator.__send__(@name)
      end

      def validate!
        presence
        _run_validations
      end

      private
      def skip?
        @value.nil?
      end

      def _run_validations
        return if skip?

        format
        coerce
      end

      def presence
        if @options[:presence] && skip?
          @errors[@name].push(:presence)
        end
      end

      def format
        if (matcher = @options[:format]) && !@value.to_s.match(matcher)
          @errors[@name].push(:format)
        end
      end

      def coerce
        if coercer = @options[:type]
          @value = Lotus::Utils::Kernel.send(coercer.to_s, @value)
          @validator.attributes[@name] = @value
        end
      end
    end
  end
end
