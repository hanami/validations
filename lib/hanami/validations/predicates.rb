require 'hanami/validations/predicate'

module Hanami
  module Validations
    module Predicates
      class UnknownPredicateError < ::StandardError
        def initialize(name)
          super("Unknown predicate: `#{ name }'")
        end
      end

      def self.register(name, predicate)
        case predicate
        when Predicate
          registry[name] = predicate
        when Proc
          register(name, Predicate.new(name, predicate))
        end
      end

      # FIXME: make it private
      # FIXME: make it thread safe
      def self.registry
        @@registry ||= Hash[]
      end

      def self.predicate(name)
        registry.fetch(name) do
          raise UnknownPredicateError.new(name)
        end
      end

      class Nil < Predicate
        def initialize
          super(:nil, ->(attr) { attr.nil? })
        end
      end

      require 'hanami/utils/blank'
      class Presence < Predicate
        def initialize
          super(:presence, ->(attr) { !Utils::Blank.blank?(attr) })
        end
      end

      class Inclusion < Predicate
        def initialize
          super(:inclusion, ->(attr, expected) { expected.include?(attr) })
        end
      end

      class Exclusion < Predicate
        def initialize
          super(:exclusion, ->(attr, expected) { !expected.include?(attr) })
        end
      end

      class Eql < Predicate
        def initialize
          super(:eql, ->(attr, expected) { attr == expected })
        end
      end

      class Empty < Predicate
        def initialize
          super(:empty, ->(attr) { attr.empty? })
        end
      end

      class Filled < Predicate
        def initialize
          super(:filled, ->(attr) { !attr.empty? })
        end
      end

      class Any < Predicate
        def initialize
          super(:any, ->(attr, &blk) {
            case attr
            when String
              result = false
              attr.each_char do |c|
                result = blk.call(c)
                return result if result
              end

              result
            when ->(a) { a.respond_to?(:any?) }
              attr.any?(&blk)
            when ->(a) { a.respond_to?(:each) }
              result = false
              attr.each do |e|
                result = blk.call(e)
                return result if result
              end

              result
            else
              raise NoMethodError.new("undefined method `any?' for #{ attr.inspect }:#{ attr.class }")
            end
          })
        end
      end

      class All < Predicate
        def initialize
          super(:all, ->(attr, &blk) {
            case attr
            when String
              result = false
              attr.each_char do |c|
                result = blk.call(c)
                return result unless result
              end

              result
            when ->(a) { a.respond_to?(:all?) }
              return false if attr.empty?
              attr.all?(&blk)
            when ->(a) { a.respond_to?(:each) }
              result = false
              attr.each do |e|
                result = blk.call(e)
                return result unless result
              end

              result
            else
              raise NoMethodError.new("undefined method `all?' for #{ attr.inspect }:#{ attr.class }")
            end
          })
        end
      end

      class Gt < Predicate
        def initialize
          super(:gt, ->(attr, expected) { attr > expected })
        end
      end

      class Gteq < Predicate
        def initialize
          super(:gteq, ->(attr, expected) { attr >= expected })
        end
      end

      class Lt < Predicate
        def initialize
          super(:lt, ->(attr, expected) { attr < expected })
        end
      end

      class Lteq < Predicate
        def initialize
          super(:lteq, ->(attr, expected) { attr <= expected })
        end
      end

      class Size < Predicate
        def initialize
          super(:size, ->(attr, expected) {
            case expected
            when Range
              expected.include?(size(attr))
            else
              size(attr) == expected
            end
          })
        end

        protected

        def size(attr)
          case attr
          when String
            attr.bytesize
          else
            attr.size
          end
        end
      end

      class Format < Predicate
        def initialize
          super(:format, ->(attr, matcher) { attr.match(matcher) })
        end
      end

      require 'hanami/validations/coercions'
      require 'hanami/utils/blank'
      class Type < Predicate
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

        def initialize
          super(:type, ->(attr, type) { coerce(attr, type) })
        end

        protected

        def coerce(attr, type)
          return Coerced.new(true, attr)  if attr.is_a?(type)
          return Coerced.new(false, attr) if attr.nil? && type != Boolean

          result = if [String, Boolean].include?(type)
                     Hanami::Validations::Coercions.coerce(type, attr) unless attr.is_a?(Array) || attr.is_a?(Hash)
                   elsif [Integer, Float].include?(type)
                     Hanami::Validations::Coercions.coerce(type, attr)
                   elsif [Date, Time].include?(type)
                     Hanami::Validations::Coercions.coerce(type, attr) unless attr.is_a?(Float) || attr.is_a?(BigDecimal)
                   elsif [DateTime].include?(type)
                     Hanami::Validations::Coercions.coerce(type, attr) unless attr.is_a?(Integer) || attr.is_a?(Float) || attr.is_a?(BigDecimal)
                   elsif [BigDecimal].include?(type)
                     Hanami::Validations::Coercions.coerce(type, attr) unless Hanami::Utils::Blank.blank?(attr)
                   else
                     Hanami::Validations::Coercions.coerce(type, attr) rescue nil
                   end

          return Coerced.new(false, result) if result.nil?
          Coerced.new(true, result)
        end
      end

      register(:nil?,       Nil.new)
      register(:presence?,  Presence.new)
      register(:present?,   Presence.new)
      register(:inclusion?, Inclusion.new)
      register(:exclusion?, Exclusion.new)
      register(:eql?,       Eql.new)
      register(:empty?,     Empty.new)
      register(:filled?,    Filled.new)
      register(:any?,       Any.new)
      register(:all?,       All.new)
      register(:gt?,        Gt.new)
      register(:gteq?,      Gteq.new)
      register(:lt?,        Lt.new)
      register(:lteq?,      Lteq.new)
      register(:size?,      Size.new)
      register(:format?,    Format.new)
      register(:type?,      Type.new)
    end
  end
end
