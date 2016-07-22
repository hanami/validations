module Hanami
  module Validations
    # Inline predicate
    #
    # @since 0.6.0
    # @api private
    class InlinePredicate
      # @since 0.6.0
      # @api private
      attr_reader :name

      # @since 0.6.0
      # @api private
      attr_reader :message

      # Return a new instance.
      #
      # @param name [Symbol] inline predicate name
      # @param message [String] optional failure message
      # @param blk [Proc] predicate implementation
      #
      # @return [Hanami::Validations::InlinePredicate] a new instance
      #
      # @since 0.6.0
      # @api private
      def initialize(name, message, &blk)
        @name    = name
        @message = message
        @blk     = blk
      end

      # @since 0.6.0
      # @api private
      def to_proc
        @blk
      end

      # @since 0.6.0
      # @api private
      def ==(other)
        self.class == other.class &&
          name == other.name
      end
    end
  end
end
