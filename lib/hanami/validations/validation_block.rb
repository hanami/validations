module Hanami
  module Validations
    # A wrapper on a validation block.
    # This wrapper binds 'self' to the validation context to evaluate the validation block
    # 
    # @since 0.x.0
    # @api private
    class ValidationBlock
      # The block to perform the validation
      #
      # @return [Proc] the validation block
      #
      # @since 0.x.0
      attr_reader :block

      # @param block  [Proc] the validation block
      #
      # @since 0.x.0
      def initialize(block)
        @block = block
      end

      # Evaluates the validation block binding 'self' to the validation context
      #
      # @param validation_context [Hanami::Validations::ValidationContext] the 
      #        validation context
      #
      # @since 0.x.0
      def call(validation_context)
        validation_context.instance_eval(&block)
      end
    end
  end
end
