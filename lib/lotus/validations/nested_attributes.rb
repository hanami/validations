module Lotus
  module Validations
    # @since 0.3.1
    # @api private
    class NestedAttributes
      # @since 0.3.1
      # @api private
      def self.fabricate(parent_validator_klass, &blk)
        dup.tap do |klass|
          klass.class_eval { include Lotus::Validations }
          klass.class_eval { @parent_validator_klass = parent_validator_klass }
          klass.class_eval(&blk)
        end
      end
    end
  end
end
