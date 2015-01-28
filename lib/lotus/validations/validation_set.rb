module Lotus
  module Validations
    # A set of validations defined on an object
    #
    # @since 0.2.2
    # @api private
    class ValidationSet
      # Allowed validations
      #
      # @since 0.2.2
      # @api private
      VALIDATIONS = [
        :presence,
        :acceptance,
        :format,
        :inclusion,
        :exclusion,
        :confirmation,
        :size,
        :type,
        :nested
      ].freeze

      # @since 0.2.2
      # @api private
      def initialize
        @validations = Hash.new {|h,k| h[k] = {} }
      end

      # @since 0.2.2
      # @api private
      def add(name, options)
        @validations[name.to_sym].merge!(
          validate_options!(name, options)
        )
      end

      # @since 0.2.2
      # @api private
      def each(&blk)
        @validations.each(&blk)
      end

      # @since 0.2.2
      # @api private
      def each_key(&blk)
        @validations.each_key(&blk)
      end

      # @since 0.2.3
      # @api private
      def names
        @validations.keys
      end

      private
      # Checks at the loading time if the user defined validations are recognized
      #
      # @param name [Symbol] the attribute name
      # @param options [Hash] the set of validations associated with the given attribute
      #
      # @raise [ArgumentError] if at least one of the validations are not
      #   recognized
      #
      # @since 0.2.2
      # @api private
      def validate_options!(name, options)
        if (unknown = (options.keys - VALIDATIONS)) && unknown.any?
          raise ArgumentError.new(%(Unknown validation(s): #{ unknown.join ', ' } for "#{ name }" attribute))
        end

        # FIXME remove
        if options[:confirmation]
          add(:"#{ name }_confirmation", {})
        end

        options
      end
    end
  end
end
