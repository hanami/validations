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
      def attribute(name, options = {})
        attributes[name.to_sym] = validate_options!(name, options)

        class_eval %{
          def #{ name }
            @attributes[:#{ name }]
          end
        }
      end

      private
      # Set of user defined attributes
      #
      # @return [Hash]
      #
      # @since 0.1.0
      # @api private
      def attributes
        @attributes ||= Hash.new
      end

      # Checks at the loading time if the user defined validations are recognized
      #
      # @param name [Symbol] the attribute name
      # @param name [Hash] the set of validations associated with the given attribute
      #
      # @raise [ArgumentError] if at least one of the validations are not
      #   recognized
      #
      # @since 0.1.0
      # @api private
      def validate_options!(name, options)
        if (unknown = (options.keys - validations)) && unknown.any?
          raise ArgumentError.new(%(Unknown validation(s): #{ unknown.join ', ' } for "#{ name }" attribute))
        end

        options
      end

      # Names of the implemented validations
      #
      # @return [Array]
      #
      # @since 0.1.0
      # @api private
      def validations
        [:presence, :acceptance, :format, :inclusion, :exclusion, :confirmation, :size, :type]
      end
    end

    # Validation errors
    #
    # @return [Lotus::Validations::Errors] the set of validation errors
    #
    # @since 0.1.0
    #
    # @see Lotus::Validations::Errors
    #
    # @example Valid attributes
    #   require 'lotus/validations'
    #
    #   class Signup
    #     include Lotus::Validations
    #
    #     attribute :email, presence: true, format: /\A(.*)@(.*)\.(.*)\z/
    #   end
    #
    #   signup = Signup.new(email: 'user@example.org')
    #   signup.valid? # => true
    #
    #   signup.errors
    #     # => #<Lotus::Validations::Errors:0x007fd594ba9228 @errors={}>
    #
    # @example Invalid attributes
    #   require 'lotus/validations'
    #
    #   class Signup
    #     include Lotus::Validations
    #
    #     attribute :email, presence: true, format: /\A(.*)@(.*)\.(.*)\z/
    #     attribute :age, size: 18..99
    #   end
    #
    #   signup = Signup.new(email: '', age: 17)
    #   signup.valid? # => false
    #
    #   signup.errors
    #     # => #<Lotus::Validations::Errors:0x007fe00ced9b78
    #       @errors={
    #         :email=>[
    #           #<Lotus::Validations::Error:0x007fe00cee3290 @attribute=:email, @validation=:presence, @expected=true, @actual="">,
    #           #<Lotus::Validations::Error:0x007fe00cee31f0 @attribute=:email, @validation=:format, @expected=/\A(.*)@(.*)\.(.*)\z/, @actual="">
    #         ],
    #         :age=>[
    #           #<Lotus::Validations::Error:0x007fe00cee30d8 @attribute=:age, @validation=:size, @expected=18..99, @actual=17>
    #         ]
    #       }>
    attr_reader :errors

    # Create a new instance with the given attributes
    #
    # @param attributes [#to_h] an Hash like object which contains the
    #   attributes
    #
    # @since 0.1.0
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
      @attributes = attributes.to_h
      @errors     = Errors.new
    end

    # Checks if the current data satisfies the defined validations
    #
    # @return [TrueClass,FalseClass] the result of the validations
    #
    # @since 0.1.0
    def valid?
      _attributes.each do |name, options|
        AttributeValidator.new(self, name, options).validate!
      end

      @errors.empty?
    end

    protected
    # Returns the attributes passed at the initialize time
    #
    # @return [Hash] attributes
    #
    # @since 0.1.0
    # @api private
    #
    # @example
    #   require 'lotus/validations'
    #
    #   class Signup
    #     include Lotus::Validations
    #
    #     attribute :email
    #   end
    #
    #   signup = Signup.new(email: 'user@example.org')
    #   signup.attributes # => {:email=>"user@example.org"}
    attr_reader :attributes

    private
    # @since 0.1.0
    # @api private
    #
    # @see Lotus::Validations::ClassMethods#attributes
    def _attributes
      self.class.__send__(:attributes)
    end
  end
end
