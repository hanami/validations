module Hanami
  module Validations
    # @since 0.3.1
    # @api private
    class NestedAttributes
      # @since 0.3.1
      # @api private
      def self.fabricate(&blk)
        dup.tap do |klass|
          klass.class_eval { include Hanami::Validations }
          klass.class_eval(&blk)
        end
      end

      # @since 0.3.1
      # @api private
      def hanami_nested_attributes?
        true
      end
    end
  end
end
