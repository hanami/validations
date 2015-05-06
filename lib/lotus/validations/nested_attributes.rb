module Lotus
  module Validations
    # @since x.x.x
    # @api private
    class NestedAttributes
      # @since x.x.x
      # @api private
      def self.fabricate(&blk)
        dup.tap do |klass|
          klass.class_eval { include Lotus::Validations }
          klass.class_eval(&blk)
        end
      end

      # @since x.x.x
      # @api private
      def lotus_nested_attributes?
        true
      end
    end
  end
end
