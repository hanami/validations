module Hanami
  module Validations
    class Predicate
      attr_reader :name

      def initialize(name, blk = -> { false })
        @name = name
        @blk  = blk
      end

      def call(*args)
        @blk.call(*args)
      end
    end
  end
end
