module Lotus
  module Validations
    class Attributes
      def initialize(definitions, attributes)
        attributes  = attributes.to_h

        @attributes = Utils::Hash.new.tap do |result|
          definitions.iterate(attributes) do |name, validations|
            value = attributes[name]
            value = attributes[name.to_s] if value.nil?

            result[name] = Attribute.new(attributes, name, value, validations)
          end
        end
      end

      def get(name)
        (attr = @attributes[name]) and attr.value
      end

      def dup
        Utils::Hash.new(to_h).deep_dup
      end

      def each(&blk)
        @attributes.each(&blk)
      end

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
