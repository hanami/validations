require 'lotus/validations/version'
require 'lotus/validations/errors'
require 'lotus/validations/attribute_validator'

module Lotus
  # Lotus::Validations is a set of lightweight validations for Ruby objects.
  #
  # @since 0.1.0
  module Validations

    # Override Ruby's hook for modules.
    #
    # @param base [Class] the target action
    #
    # @since 0.1.0
    # @api private
    #
    # @see http://www.ruby-doc.org/core/Module.html#method-i-included
    def self.included(base)
      base.extend ClassMethods
    end

    # Validations DSL
    #
    # @since 0.1.0
    module ClassMethods
      # Define an attribute
      #
      # @param name [#to_sym] the name of the attribute
      # @param options [Hash] optional set of validations
      # @option options [Class] :type the Ruby type used to coerce the value
      # @option options [TrueClass,FalseClass] :acceptance requires Ruby
      #   thruthiness of the value
      # @option options [TrueClass,FalseClass] :confirmation requires the value
      #   to be confirmed twice
      # @option options [#include?] :exclusion requires the value NOT be
      #   included in the given collection
      # @option options [Regexp] :format requires value to match the given
      #   Regexp
      # @option options [#include?] :inclusion requires the value BE included in
      #   the given collection
      # @option options [TrueClass,FalseClass] :presence requires the value be
      #   included in the given collection
      # @option options [Numeric,Range] :size requires value's to be equal or
      #   included by the given validator
      #
      # @raise [ArgumentError] if an unknown or mispelled validation is given
      #
      # @example Attributes
      #   require 'lotus/validations'
      #
      #   class Person
      #     include Lotus::Validations
      #
      #     attribute :name
      #   end
      #
      #   person = Person.new(name: 'Luca', age: 32)
      #   person.name # => "Luca"
      #   person.age  # => raises NoMethodError because `:age` wasn't defined as attribute.
      #
      # @example Standard coercions
      #   require 'lotus/validations'
      #
      #   class Person
      #     include Lotus::Validations
      #
      #     attribute :fav_number, type: Integer
      #   end
      #
      #   person = Person.new(fav_number: '23')
      #   person.fav_number # => 23
      #
      # @example Custom coercions
      #   require 'lotus/validations'
      #
      #   class FavNumber
      #     def initialize(number)
      #       @number = number
      #     end
      #   end
      #
      #   class BirthDate
      #   end
      #
      #   class Person
      #     include Lotus::Validations
      #
      #     attribute :fav_number, type: FavNumber
      #     attribute :date,       type: BirthDate
      #   end
      #
      #   person.fav_number # => 23
      #   person.date       # => this raises an error, because BirthDate#initialize doesn't accept any arg
      def attribute(name, options = {})
        attributes[name.to_sym] = validate_options!(name, options)

        class_eval %{
          def #{ name }
            @attributes[:#{ name }]
          end
        }
      end

      private
      def attributes
        @attributes ||= Hash.new
      end

      def validate_options!(name, options)
        if (unknown = (options.keys - validations)) && unknown.any?
          raise ArgumentError.new(%(Unknown validation(s): #{ unknown.join ', ' } for "#{ name }" attribute))
        end

        options
      end

      def validations
        [:presence, :acceptance, :format, :inclusion, :exclusion, :confirmation, :size, :type]
      end
    end

    attr_reader :attributes, :errors

    def initialize(attributes)
      @attributes = attributes
      @errors     = Errors.new
    end

    def valid?
      _attributes.each do |name, options|
        AttributeValidator.new(self, name, options).validate!
      end

      @errors.empty?
    end

    private
    def _attributes
      self.class.__send__(:attributes)
    end
  end
end
