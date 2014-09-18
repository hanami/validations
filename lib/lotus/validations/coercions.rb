require 'lotus/utils/kernel'

module Lotus
  module Validations
    module Coercions
      def self.coerce(coercer, *values, &blk)
        if ::Lotus::Utils::Kernel.respond_to?(coercer.to_s)
          ::Lotus::Utils::Kernel.__send__(coercer.to_s, *values, &blk)
        else
          coercer.new(*values, &blk)
        end
      end
    end
  end
end
