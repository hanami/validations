module Lotus
  module Validations
    class Error
      attr_reader :attribute, :validation, :expected, :actual

      def initialize(attribute, validation, expected, actual)
        @attribute, @validation, @expected, @actual =
          attribute, validation, expected, actual
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.attribute  == attribute  &&
          other.validation == validation &&
          other.expected   == expected   &&
          other.actual     == actual
      end
    end
  end
end
