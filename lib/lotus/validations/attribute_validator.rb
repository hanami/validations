require 'lotus/utils/kernel'

class Range
  def size
    to_a.size
  end unless instance_methods.include?(:size)
end

module Lotus
  module Validations
    class AttributeValidator
      def initialize(validator, name, options)
        @validator, @name, @options = validator, name, options
        @value = @validator.__send__(@name)
      end

      def validate!
        presence
        acceptance

        _run_validations
      end

      private
      def presence
        _validate(__method__) { !skip? }
      end

      def acceptance
        _validate(__method__) { Lotus::Utils::Kernel.Boolean(@value) }
      end

      def format
        _validate(__method__) {|matcher| @value.to_s.match(matcher) }
      end

      def inclusion
        _validate(__method__) {|collection| collection.include?(@value) }
      end

      def size
        _validate(__method__) do |validator|
          case validator
          when Numeric, ->(v) { v.respond_to?(:to_int) }
            @value.size == validator.to_int
          when Range
            validator.include?(@value.size)
          else
            raise ArgumentError.new("Size validator must be a number or a range, it was: #{ validator }")
          end
        end
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
        size
      end

      def _validate(validation)
        if (validator = @options[validation]) && !(yield validator)
          @validator.errors[@name].push(validation)
        end
      end

    end
  end
end
