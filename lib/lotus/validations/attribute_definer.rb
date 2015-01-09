require 'set'
require 'lotus/utils/attributes'

module Lotus
  module Validations
    # Define attributes and their validations together
    #
    # @since 0.2.2
    # @api private
    module AttributeDefiner
      # Override Ruby's hook for modules.
      #
      # @param base [Class] the target class
      #
      # @since 0.2.2
      # @api private
      #
      # @see http://www.ruby-doc.org/core/Module.html#method-i-included
      def self.included(base)
        base.extend ClassMethods
      end

      # @since 0.2.2
      # @api private
      module ClassMethods
        # Override Ruby's hook for modules.
        #
        # @param base [Class] the target class
        #
        # @since 0.2.2
        # @api private
        #
        # @see http://www.ruby-doc.org/core/Module.html#method-i-extended
        def included(base)
          super
          base.defined_attributes.merge(defined_attributes)
        end

        # Override Ruby's hook for modules.
        #
        # @param base [Class] the target class
        #
        # @since 0.2.2
        # @api private
        #
        # @see http://www.ruby-doc.org/core/Module.html#method-i-extended
        def inherited(base)
          super
          base.defined_attributes.merge(defined_attributes)
        end

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
        # @since 0.2.2
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
        #   person.valid?
        #
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
        #   person = Person.new(fav_number: '23', date: 'Oct 23, 2014')
        #   person.valid?
        #
        #   person.fav_number # => 23
        #   person.date       # => this raises an error, because BirthDate#initialize doesn't accept any arg
        #
        # @example Acceptance
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :terms_of_service, acceptance: true
        #   end
        #
        #   signup = Signup.new(terms_of_service: '1')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(terms_of_service: '')
        #   signup.valid? # => false
        #
        # @example Confirmation
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :password, confirmation: true
        #   end
        #
        #   signup = Signup.new(password: 'secret', password_confirmation: 'secret')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(password: 'secret', password_confirmation: 'x')
        #   signup.valid? # => false
        #
        # @example Exclusion
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :music, exclusion: ['pop']
        #   end
        #
        #   signup = Signup.new(music: 'rock')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(music: 'pop')
        #   signup.valid? # => false
        #
        # @example Format
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :name, format: /\A[a-zA-Z]+\z/
        #   end
        #
        #   signup = Signup.new(name: 'Luca')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(name: '23')
        #   signup.valid? # => false
        #
        # @example Inclusion
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :age, inclusion: 18..99
        #   end
        #
        #   signup = Signup.new(age: 32)
        #   signup.valid? # => true
        #
        #   signup = Signup.new(age: 17)
        #   signup.valid? # => false
        #
        # @example Presence
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :name, presence: true
        #   end
        #
        #   signup = Signup.new(name: 'Luca')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(name: nil)
        #   signup.valid? # => false
        #
        # @example Size
        #   require 'lotus/validations'
        #
        #   class Signup
        #     MEGABYTE = 1024 ** 2
        #     include Lotus::Validations
        #
        #     attribute :ssn,      size: 11    # exact match
        #     attribute :password, size: 8..64 # range
        #     attribute :avatar,   size  1..(5 * MEGABYTE)
        #   end
        #
        #   signup = Signup.new(password: 'a-very-long-password')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(password: 'short')
        #   signup.valid? # => false

        def attribute(name, options = {}, &block)
          if block_given?
            nested_class = build_validation_class(&block)
            define_lazy_reader(name, nested_class)
            define_coerced_writer(name, nested_class)
            validates(name, {})
          else
            define_attribute(name, options)
            validates(name, options)
          end
        end

        def defined_attributes
          @defined_attributes ||= Set.new
        end

        private

        # @since 0.2.2
        # @api private
        def define_attribute(name, options)
          type = options.delete(:type)
          define_accessor(name, type)
          defined_attributes.add(name.to_s)

          if options[:confirmation]
            confirmation_accessor = "#{ name }_confirmation"
            define_accessor(confirmation_accessor, type)
            defined_attributes.add(confirmation_accessor)
          end
        end

        # @since 0.2.2
        # @api private
        def define_accessor(name, type)
          if type
            define_reader(name)
            define_coerced_writer(name, type)
          else
            define_reader(name)
            define_writer(name)
          end
        end

        # @since 0.2.2
        # @api private
        def define_coerced_writer(name, type)
          define_method("#{ name }=") do |value|
            @attributes.set(name, Lotus::Validations::Coercions.coerce(type, value))
          end
        end

        # @since 0.2.2
        # @api private
        def define_writer(name)
          define_method("#{ name }=") do |value|
            @attributes.set(name, value)
          end
        end

        # @since 0.2.2
        # @api private
        def define_reader(name)
          define_method(name) do
            @attributes.get(name)
          end
        end

        # Defines a reader that will return a new instance of
        # the given type if one is not already present
        #
        # @since x.x.x
        # @api private
        def define_lazy_reader(name, type)
          define_method(name) do
            value = @attributes.get(name)
            return value if value
            type.new({}).tap do |value|
              @attributes.set(name, value)
            end
          end
        end

        # Creates a validation class and configures it with the
        # given block.
        #
        # @since x.x.x
        # @api private
        def build_validation_class(&block)
          kls = Class.new do
            include Lotus::Validations
          end
          kls.class_eval(&block)
          kls
        end
      end

      # Create a new instance with the given attributes
      #
      # @param attributes [#to_h] an Hash like object which contains the
      #   attributes
      #
      # @since 0.2.2
      #
      # @example Initialize with Hash
      #   require 'lotus/validations'
      #
      #   class Signup
      #     include Lotus::Validations
      #
      #     attribute :name
      #   end
      #
      #   signup = Signup.new(name: 'Luca')
      #
      # @example Initialize with Hash like
      #   require 'lotus/validations'
      #
      #   class Params
      #     def initialize(attributes)
      #       @attributes = Hash[*attributes]
      #     end
      #
      #     def to_h
      #       @attributes.to_h
      #     end
      #   end
      #
      #   class Signup
      #     include Lotus::Validations
      #
      #     attribute :name
      #   end
      #
      #   params = Params.new([:name, 'Luca'])
      #   signup = Signup.new(params)
      #
      #   signup.name # => "Luca"
      def initialize(attributes)
        @attributes ||= Utils::Attributes.new

        attributes.to_h.each do |key, value|
          public_send("#{ key }=", value) if assign_attribute?(key)
        end
      end

      private
      # @since 0.2.2
      # @api private
      def assign_attribute?(attr)
        self.class.defined_attributes.include?(attr.to_s)
      end
    end
  end
end
