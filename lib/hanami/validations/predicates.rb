require 'hanami/validations/predicate'

module Hanami
  module Validations
    module Predicates
      def self.register(name, predicate)
        registry[name] = predicate
      end

      # FIXME: make it private
      # FIXME: make it thread safe
      def self.registry
        @@registry ||= Hash[]
      end

      def self.call(name, attr, *args)
        registry.fetch(name).call(attr, *args)
      end

      class Presence < Predicate
        def initialize
          super(:presence, ->(attr) { !attr.nil? })
        end
      end

      class Inclusion < Predicate
        def initialize
          super(:inclusion, ->(attr, expected) { expected.include?(attr) })
        end
      end

      register(:presence?,  Presence.new)
      register(:inclusion?, Inclusion.new)
    end
  end
end
