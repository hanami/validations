# Lotus::Validations

Validations mixins for objects

## Status

[![Gem Version](http://img.shields.io/gem/v/lotus-validations.svg)](https://badge.fury.io/rb/lotus-validations)
[![Build Status](http://img.shields.io/travis/lotus/validations/master.svg)](https://travis-ci.org/lotus/validations?branch=master)
[![Coverage](http://img.shields.io/coveralls/lotus/validations/master.svg)](https://coveralls.io/r/lotus/validations)
[![Code Climate](http://img.shields.io/codeclimate/github/lotus/validations.svg)](https://codeclimate.com/github/lotus/validations)
[![Dependencies](http://img.shields.io/gemnasium/lotus/validations.svg)](https://gemnasium.com/lotus/validations)
[![Inline Docs](http://inch-ci.org/github/lotus/validations.svg)](http://inch-ci.org/github/lotus/validations)

## Contact

* Home page: http://lotusrb.org
* Mailing List: http://lotusrb.org/mailing-list
* API Doc: http://rdoc.info/gems/lotus-validations
* Bugs/Issues: https://github.com/lotus/validations/issues
* Support: http://stackoverflow.com/questions/tagged/lotus-ruby
* Chat: https://gitter.im/lotus/chat

## Rubies

__Lotus::Validations__ supports Ruby (MRI) 2+, JRuby 1.7 (with 2.0 mode) and Rubinius 2.3.0+.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lotus-validations'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lotus-validations

## Usage

`Lotus::Validations` is a set of lightweight validations for Ruby objects.

### Attributes

The framework allows you to define attributes for each object.

It defines an initializer, whose attributes can be passed as a hash.
All unknown values are ignored, which is useful for whitelisting attributes.

```ruby
require 'lotus/validations'

class Person
  include Lotus::Validations

  attribute :name,  presence: true
  attribute :email, presence: true
end

person = Person.new(name: 'Luca', email: 'me@example.org', age: 32)
person.name  # => "Luca"
person.email # => "me@example.org"
person.age   # => raises NoMethodError because `:age` wasn't defined as attribute.
```

### Validations

If you prefer Lotus::Validations to **only define validations**, but **not attributes**,
you can use the following alternative syntax.

```ruby
require 'lotus/validations'

class Person
  include Lotus::Validations
  attr_accessor :name, :email

  # Custom initializer
  def initialize(attributes = {})
    @name, @email = attributes.values_at(:name, :email)
  end

  validates :name,  presence: true
  validates :email, presence: true
end

person = Person.new(name: 'Luca', email: 'me@example.org')
person.name  # => "Luca"
person.email # => "me@example.org"
```

This is a bit more verbose, but offers a great level of flexibility for your
Ruby objects. It also allows to use Lotus::Validations in combination with
**other frameworks**.

### Coercions

If a Ruby class is passed to the `:type` option, the given value is coerced, accordingly.

#### Standard coercions

```ruby
require 'lotus/validations'

class Person
  include Lotus::Validations

  attribute :fav_number, type: Integer
end

person = Person.new(fav_number: '23')
person.valid?

person.fav_number # => 23
```

Allowed types are:

  * `Array`
  * `BigDecimal`
  * `Boolean`
  * `Date`
  * `DateTime`
  * `Float`
  * `Hash`
  * `Integer`
  * `Pathname`
  * `Set`
  * `String`
  * `Symbol`
  * `Time`

#### Custom coercions

If a user defined class is specified, it can be freely used for coercion purposes.
The only limitation is that the constructor should have **arity of 1**.

```ruby
require 'lotus/validations'

class FavNumber
  def initialize(number)
    @number = number
  end
end

class BirthDate
end

class Person
  include Lotus::Validations

  attribute :fav_number, type: FavNumber
  attribute :date,       type: BirthDate
end

person = Person.new(fav_number: '23', date: 'Oct 23, 2014')
person.valid?

person.fav_number # => #<FavNumber:0x007ffc644bba00 @number="23">
person.date       # => this raises an error, because BirthDate#initialize doesn't accept any arg
```

### Validations

Each attribute definition can receive a set of options to define one or more
validations.

**Validations are triggered when you invoke `#valid?`.**

#### Acceptance

An attribute is valid if it's value satisfies [Ruby's _truthiness_](http://ruby.about.com/od/control/a/Boolean-Expressions.htm).

```ruby
require 'lotus/validations'

class Signup
  include Lotus::Validations

  attribute :terms_of_service, acceptance: true
end

signup = Signup.new(terms_of_service: '1')
signup.valid? # => true

signup = Signup.new(terms_of_service: '')
signup.valid? # => false
```

#### Confirmation

An attribute is valid if it's value and the value of a corresponding attribute
is valid.

By convention, if you have a `password` attribute, the validation looks for `password_confirmation`.

```ruby
require 'lotus/validations'

class Signup
  include Lotus::Validations

  attribute :password, confirmation: true
end

signup = Signup.new(password: 'secret', password_confirmation: 'secret')
signup.valid? # => true

signup = Signup.new(password: 'secret', password_confirmation: 'x')
signup.valid? # => false
```

#### Exclusion

An attribute is valid, if the value isn't excluded from the value described by
the validator.

The validator value can be anything that responds to `#include?`.
In Ruby, this includes most of the core objects: `String`, `Enumerable` (`Array`, `Hash`,
`Range`, `Set`).

See also [Inclusion](#inclusion).

```ruby
require 'lotus/validations'

class Signup
  include Lotus::Validations

  attribute :music, exclusion: ['pop']
end

signup = Signup.new(music: 'rock')
signup.valid? # => true

signup = Signup.new(music: 'pop')
signup.valid? # => false
```

#### Format

An attribute is valid if it matches the given Regular Expression.

```ruby
require 'lotus/validations'

class Signup
  include Lotus::Validations

  attribute :name, format: /\A[a-zA-Z]+\z/
end

signup = Signup.new(name: 'Luca')
signup.valid? # => true

signup = Signup.new(name: '23')
signup.valid? # => false
```

#### Inclusion

An attribute is valid, if the value provided is included in the validator's
value.

The validator value can be anything that responds to `#include?`.
In Ruby, this includes most of the core objects: like `String`, `Enumerable` (`Array`, `Hash`,
`Range`, `Set`).

See also [Exclusion](#exclusion).

```ruby
require 'prime'
require 'lotus/validations'

class PrimeNumbers
  def initialize(limit)
    @numbers = Prime.each(limit).to_a
  end

  def include?(number)
    @numbers.include?(number)
  end
end

class Signup
  include Lotus::Validations

  attribute :age,        inclusion: 18..99
  attribute :fav_number, inclusion: PrimeNumbers.new(100)
end

signup = Signup.new(age: 32)
signup.valid? # => true

signup = Signup.new(age: 17)
signup.valid? # => false

signup = Signup.new(fav_number: 23)
signup.valid? # => true

signup = Signup.new(fav_number: 8)
signup.valid? # => false
```

#### Presence

An attribute is valid if present.

```ruby
require 'lotus/validations'

class Signup
  include Lotus::Validations

  attribute :name, presence: true
end

signup = Signup.new(name: 'Luca')
signup.valid? # => true

signup = Signup.new(name: '')
signup.valid? # => false

signup = Signup.new(name: nil)
signup.valid? # => false
```

#### Size

An attribute is valid if it's `#size` falls within the described value.

```ruby
require 'lotus/validations'

class Signup
  MEGABYTE = 1024 ** 2
  include Lotus::Validations

  attribute :ssn,      size: 11    # exact match
  attribute :password, size: 8..64 # range
  attribute :avatar,   size: 1..(5 * MEGABYTE)
end

signup = Signup.new(password: 'a-very-long-password')
signup.valid? # => true

signup = Signup.new(password: 'short')
signup.valid? # => false
```

**Note that in the example above you are able to validate the weight of the file,
because Ruby's `File` and `Tempfile` both respond to `#size`.**

#### Uniqueness

Uniqueness validations aren't implemented because this library doesn't deal with persistence.
The other reason is that this isn't an effective way to ensure uniqueness of a value in a database.

Please read more at: [The Perils of Uniqueness Validations](http://robots.thoughtbot.com/the-perils-of-uniqueness-validations).

### Nested validations

Nested validations are handled with a nested block syntax.

```ruby
class ShippingDetails
  include Lotus::Validations

  attribute :full_name, presence: true

  attribute :address do
    attribute :street,      presence: true
    attribute :city,        presence: true
    attribute :country,     presence: true
    attribute :postal_code, presence: true, format: /.../
  end
end

validator = ShippingDetails.new
validator.valid? # => false
```

Bulk operations on errors are guaranteed by `#each`.
This method yields a **flattened collection of errors**.

```ruby
validator.errors.each do |error|
  error.name
    # => on the first iteration it returns "full_name"
    # => the second time it returns "address.street" and so on..
end
```

Errors for a specific attribute can be accessed via `#for`.

```ruby
error = validator.errors.for('full_name').first
error.name           # => "full_name"
error.attribute_name # => "full_name"

error = validator.errors.for('address.street').first
error.name           # => "address.street"
error.attribute_name # => "street"
```

### Composable validations

Validations can be reused via composition:

```ruby
require 'lotus/validations'

module NameValidations
  include Lotus::Validations

  attribute :name, presence: true
end

module EmailValidations
  include Lotus::Validations

  attribute :email, presence: true, format: /.../
end

module PasswordValidations
  include Lotus::Validations

  # We validate only the presence here
  attribute :password, presence: true
end

module CommonValidations
  include EmailValidations
  include PasswordValidations
end

# A valid signup requires:
#   * name (presence)
#   * email (presence and format)
#   * password (presence and confirmation)
class Signup
  include NameValidations
  include CommonValidations

  # We decorate PasswordValidations behavior, by requiring the confirmation too.
  # This additional validation is active only in this case.
  attribute :password, confirmation: true
end

# A valid signin requires:
#   * email (presence)
#   * password (presence)
class Signin
  include CommonValidations
end

# A valid "forgot password" requires:
#   * email (presence)
class ForgotPassword
  include EmailValidations
end
```

### Complete example

```ruby
require 'lotus/validations'

class Signup
  include Lotus::Validations

  attribute :first_name, presence: true
  attribute :last_name,  presence: true
  attribute :email,      presence: true, format: /\A(.*)@(.*)\.(.*)\z/
  attribute :password,   presence: true, confirmation: true, size: 8..64
end
```

### Errors

When you invoke `#valid?`, validation errors are available at `#errors`.
It's a set of errors grouped by attribute. Each error contains the name of the
invalid attribute, the failed validation, the expected value, and the current one.

```ruby
require 'lotus/validations'

class Signup
  include Lotus::Validations

  attribute :email, presence: true, format: /\A(.*)@(.*)\.(.*)\z/
  attribute :age, size: 18..99
end

signup = Signup.new(email: 'user@example.org')
signup.valid? # => true

signup = Signup.new(email: '', age: 17)
signup.valid? # => false

signup.errors
  # => #<Lotus::Validations::Errors:0x007fe00ced9b78
  # @errors={
  #   :email=>[
  #     #<Lotus::Validations::Error:0x007fe00cee3290 @attribute=:email, @validation=:presence, @expected=true, @actual="">,
  #     #<Lotus::Validations::Error:0x007fe00cee31f0 @attribute=:email, @validation=:format, @expected=/\A(.*)@(.*)\.(.*)\z/, @actual="">
  #   ],
  #   :age=>[
  #     #<Lotus::Validations::Error:0x007fe00cee30d8 @attribute=:age, @validation=:size, @expected=18..99, @actual=17>
  #   ]
  # }>
```

### Lotus::Entity

Integration with [`Lotus::Entity`](https://github.com/lotus/model) is straight forward.

```ruby
require 'lotus/model'
require 'lotus/validations'

class Product
  include Lotus::Entity
  include Lotus::Validations

  attribute :name,  type: String,  presence: true
  attribute :price, type: Integer, presence: true
end

product = Product.new(name: 'Book', price: '100')
product.valid? # => true

product.name  # => "Book"
product.price # => 100
```

## Contributing

1. Fork it ( https://github.com/lotus/lotus-validations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright © 2014-2015 Luca Guidi – Released under MIT License
