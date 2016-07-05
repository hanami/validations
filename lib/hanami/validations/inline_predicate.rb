module Hanami
  module Validations
    # Inline predicate
    #
    # @since x.x.x
    # @api private
    class InlinePredicate
      # @since x.x.x
      # @api private
      attr_reader :name

      # @since x.x.x
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
      # @since x.x.x
      # @api private
      def initialize(name, message, &blk)
        @name    = name
        @message = message
        @blk     = blk
      end

      # @since x.x.x
      # @api private
      def to_proc
        @blk
      end

      # @since x.x.x
      # @api private
      def ==(other)
        self.class == other.class &&
          name == other.name
      end
    end
  end
end
