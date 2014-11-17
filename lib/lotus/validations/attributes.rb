module Lotus
  module Validations
    class Attributes
      def initialize(definitions, attributes)
        attributes  = attributes.to_h

        @attributes = Utils::Hash.new.tap do |result|
          definitions.each do |name, validations|
            result[name] = Attribute.new(self, name, attributes[name], validations)
          end
        end
      end

      def get(name)
        @attributes[name].value
      end

      def dup
        Utils::Hash.new(to_h).deep_dup
      end

      def each(&blk)
        @attributes.each(&blk)
      end

      # FIXME remove
      def to_h
        ::Hash.new.tap do |result|
          each do |name, _|
            result[name] = get(name)
          end
        end
      end
    end
  end
end
