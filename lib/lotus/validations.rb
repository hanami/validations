require 'set'
require 'lotus/validations/version'
require 'lotus/utils/kernel'

module Lotus
  module Validations
    def self.included(base)
      base.extend ClassMethods
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def valid?
      self.class.attributes.each do |attribute, options|
        if value = @attributes.fetch(attribute) { nil }

          if coercer = options.fetch(:type) { nil }
            value = Lotus::Utils::Kernel.send(coercer.to_s, value)
          end

          @attributes[attribute] = value
        end
      end
    end

    module ClassMethods
      def attribute(name, options = {})
        attributes << [name, options]

        class_eval %{
          def #{ name }
            @attributes.fetch(:#{ name })
          end
        }
      end

      # FIXME make this private
      def attributes
        @attributes ||= Set.new
      end
    end
  end
end
