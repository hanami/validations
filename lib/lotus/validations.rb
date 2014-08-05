require 'lotus/utils/kernel'
require 'lotus/validations/version'

module Lotus
  module Validations
    def self.included(base)
      base.extend ClassMethods
    end

    attr_reader :errors

    def initialize(attributes, locals = {})
      @attributes = attributes
      @locals     = locals
      @errors     = Hash.new {|h,k| h[k] = [] }
    end

    def valid?
      self.class.attributes.all? do |attribute, options|
        value = __send__(attribute)

        if options[:presence]
          if value.nil?
            @errors[attribute].push :presence
          end
        end

        if !value.nil?
          if format = options[:format]
            if !value.to_s.match(format)
              @errors[attribute].push :format
            end
          end

          if coercer = options[:type]
            value = Lotus::Utils::Kernel.send(coercer.to_s, value)
          end

          if exclusion = options[:exclusion]
            values =
              if exclusion.respond_to?(:call)
                instance_exec(&exclusion)
              else
                exclusion
              end

            if values.include?(value)
              @errors[attribute].push :exclusion
            end
          end

          @attributes[attribute] = value
        end

        @errors.empty?
      end
    end

    def method_missing(m)
      if @locals.has_key?(m)
        @locals[m]
      else
        super
      end
    end

    module ClassMethods
      def attribute(name, options = {})
        attributes[name] = options

        class_eval %{
          def #{ name }
            @attributes[:#{ name }]
          end
        }
      end

      # FIXME make this private
      def attributes
        @attributes ||= Hash.new
      end
    end
  end
end
