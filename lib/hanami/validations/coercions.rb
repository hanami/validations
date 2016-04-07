require 'hanami/utils/kernel'
require 'hanami/utils/blank'
require 'bigdecimal'

module Hanami
  module Validations
    # Coercions for attribute's values.
    #
    # @since 0.1.0
    # @api private
    module Coercions
      TYPES = {
        Array      => :collection,
        BigDecimal => :numeric,
        Boolean    => :boolean,
        Date       => :time,
        DateTime   => :time,
        Float      => :numeric,
        Hash       => :collection,
        Integer    => :numeric,
        String     => :string,
        Time       => :time
      }.freeze

      BOOLEANS = [0, 1].freeze

      class Coerced
        attr_reader :value

        def initialize(success, value)
          @success = success
          @value   = value
        end

        def success?
          @success
        end
      end

      # Coerces the given values with the given type
      #
      # @param coercer [Class] the type
      # @param value [Array] of objects to be coerced
      # @param blk [Proc] an optional block to pass to the custom coercer
      #
      # @return [Hanami::Validations::Coercions] The result of the coercion
      #
      # @since 0.1.0
      # @api private
      def self.coerce(coercer, value, &blk)
        return failure! if value.nil?
        __send__(TYPES.fetch(coercer, :custom), coercer, value, &blk)
      end

      private

      def self.string(coercer, value)
        case value
        when Array, Hash, TrueClass, FalseClass
          failure!
        else
          _coerce(coercer, value)
        end
      end

      def self.collection(coercer, value)
        if value.is_a?(coercer)
          _coerce(coercer, value)
        else
          failure!
        end
      end

      def self.numeric(coercer, value)
        if value.is_a?(Numeric) || Utils::Kernel.numeric?(value.to_s)
          _coerce(coercer, value)
        else
          failure!
        end
      end

      def self.boolean(coercer, value)
        case value
        when Hash, Utils::Hash, Array, Float, BigDecimal, Date, Time
          failure!
        when ->(v) { v.is_a?(Integer) && !BOOLEANS.include?(v) }
          failure!
        else
          _coerce(coercer, value)
        end
      end

      def self.time(coercer, value)
        case value
        when Numeric
          failure!
        else
          _coerce(coercer, value)
        end
      end

      def self.custom(coercer, value, &blk)
        begin
          success! coercer.new(value, &blk)
        rescue
          failure!
        end
      end

      def self._coerce(coercer, value)
        success! Utils::Kernel.__send__(coercer.to_s, value)
      rescue
        failure!
      end

      def self.failure!
        Coerced.new(false, nil)
      end

      def self.success!(value)
        Coerced.new(true, value)
      end
    end
  end
end
