module Hanami
  module Validations
    class InlinePredicate
      attr_reader :name, :message

      def initialize(name, message, &blk)
        @name    = name
        @message = message
        @blk     = blk
      end

      def to_proc
        @blk
      end

      def ==(other)
        self.class == other.class &&
          name == other.name
      end
    end
  end
end
