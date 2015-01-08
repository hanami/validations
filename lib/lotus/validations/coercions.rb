require 'lotus/utils/kernel'

module Lotus
  module Validations
    # Coercions for attribute's values.
    #
    # @since 0.1.0
    # @api private
    module Coercions
      # Coerces the given values with the given type
      #
      # @param coercer [Class] the type
      # @param value [Array] of objects to be coerced
      # @param blk [Proc] an optional block to pass to the custom coercer
      #
      # @return [Object,nil] The result of the coercion, if possible
      #
      # @raise [ArgumentError] if the custom coercer's `#initialize` has a wrong arity.
      #
      # @since 0.1.0
      # @api private
      def self.coerce(coercer, value, &blk)
        if ::Lotus::Utils::Kernel.respond_to?(coercer.to_s)
          ::Lotus::Utils::Kernel.__send__(coercer.to_s, value, &blk) rescue nil
        else
          coercer.new(value, &blk)
        end
      end
    end
  end
end
