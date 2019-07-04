# Hanami::Validations

Data validation library for Ruby

## Status

[![Gem Version](https://badge.fury.io/rb/hanami-validations.svg)](https://badge.fury.io/rb/hanami-validations)
[![TravisCI](https://travis-ci.org/hanami/validations.svg?branch=master)](https://travis-ci.org/hanami/validations)
[![CircleCI](https://circleci.com/gh/hanami/validations/tree/master.svg?style=svg)](https://circleci.com/gh/hanami/validations/tree/master)
[![Build Status](https://ci.hanamirb.org/api/badges/hanami/validations/status.svg)](https://ci.hanamirb.org/hanami/validations)
[![Test Coverage](https://codecov.io/gh/hanami/validations/branch/master/graph/badge.svg)](https://codecov.io/gh/hanami/validations)
[![Depfu](https://badges.depfu.com/badges/af6c6be539d9d587c7541ae7a013c9ff/overview.svg)](https://depfu.com/github/hanami/validations?project=Bundler)
[![Inline Docs](http://inch-ci.org/github/hanami/validations.svg)](http://inch-ci.org/github/hanami/validations)

## Contact

* Home page: http://hanamirb.org
* Community: http://hanamirb.org/community
* Guides: https://guides.hanamirb.org
* Mailing List: http://hanamirb.org/mailing-list
* API Doc: http://rdoc.info/gems/hanami-validations
* Bugs/Issues: https://github.com/hanami/validations/issues
* Support: http://stackoverflow.com/questions/tagged/hanami
* Chat: http://chat.hanamirb.org

## Rubies

__Hanami::Validations__ supports Ruby (MRI) 2.4+ and JRuby 9.2+

## Installation

Add this line to your application's Gemfile:

```ruby
gem "hanami-validations"
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install hanami-validations
```

## Usage

[Hanami](http://hanamirb.org), [ROM](https://rom-rb.org), and [DRY](https://dry-rb.org) projects are working together to create a strong Ruby ecosystem.
`hanami-validations` is based on [`dry-validation`](https://dry-rb.org/gems/dry-validation), for this reason the documentation explains the basics of this gem, but for advanced topics, it links to `dry-validation` docs.

### Overview

The main object provided by this gem is `Hanami::Validator`.
It providers a powerful DSL to define a validation contract, which is made of a schema and optional rules.

A validation **schema** is a set of steps that filters, coerces, and checks the validity of incoming data.
Validation **rules** are a set of directives, to check if business rules are respected.

Only when the input is formally valid (according to the **schema**), validation **rules** are checked.

```ruby
# frozen_string_literal: true

require "hanami/validations"

class SignupValidator < Hanami::Validator
  schema do
    required(:email).value(:string)
    required(:age).value(:integer)
  end

  rule(:age) do
    key.failure("must be greater than 18") if value < 18
  end
end

validator = SignupValidator.new

result = validator.call(email: "user@hanamirb.test", age: 37)
result.success? # => true

result = validator.call(email: "user@hanamirb.test", age: "foo")
result.success? # => false
result.errors.to_h # => {:age=>["must be an integer"]}

result = validator.call(email: "user@hanamirb.test", age: 17)
puts result.success? # => false
puts result.errors.to_h # => {:age=>["must be greater than 18"]}
```

### Schemas

A basic schema doesn't apply data coercion, input must already have the right Ruby types.

```ruby
# frozen_string_literal: true

require "hanami/validations"

class SignupValidator < Hanami::Validator
  schema do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end

validator = SignupValidator.new

result = validator.call(email: "user@hanamirb.test", age: 37)
puts result.success? # => true

result = validator.call(email: "user@hanamirb.test", age: "37")
puts result.success? # => false
puts result.errors.to_h # => {:age=>["must be an integer"]}
```

### Params

When used in _params mode_, a schema applies data coercion, before to run validation checks.

This is designed for Web form/HTTP params.

```ruby
# frozen_string_literal: true

require "bundler/setup"
require "hanami/validations"

class SignupValidator < Hanami::Validator
  params do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end

validator = SignupValidator.new

result = validator.call(email: "user@hanamirb.test", age: "37")
puts result.success? # => true
puts result.to_h # => {:email=>"user@hanamirb.test", :age=>37}
```

### JSON

When used in _JSON mode_, data coercions are still applied, but they follow different policies.
For instance, because JSON supports integers, strings won't be coerced into integers.

```ruby
# frozen_string_literal: true

require "hanami/validations"

class SignupValidator < Hanami::Validator
  json do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end

validator = SignupValidator.new

result = validator.call(email: "user@hanamirb.test", age: 37)
puts result.success? # => true
puts result.to_h # => {:email=>"user@hanamirb.test", :age=>37}

result = validator.call(email: "user@hanamirb.test", age: "37")
puts result.success? # => false
```

### Whitelisting

Unknown keys from incoming data are filtered out:

```ruby
# frozen_string_literal: true

require "hanami/validations"

class SignupValidator < Hanami::Validator
  schema do
    required(:email).value(:string)
  end
end

validator = SignupValidator.new

result = validator.call(email: "user@hanamirb.test", foo: "bar")
puts result.success? # => true
puts result.to_h # => {:email=>"user@hanamirb.test"}
```

### Custom Types

```ruby
# frozen_string_literal: true

require "hanami/validations"

module Types
  include Dry::Types()

  StrippedString = Types::String.constructor(&:strip)
end

class SignupValidator < Hanami::Validator
  params do
    required(:email).value(Types::StrippedString)
    required(:age).value(:integer)
  end
end

validator = SignupValidator.new

result = validator.call(email: "     user@hanamirb.test     ", age: "37")
puts result.success? # => true
puts result.to_h # => {:email=>"user@hanamirb.test", :age=>37}
```

### Rules

Rules are performing a set of domain-specific validation checks.
Rules are executed only after the validations from the schema are satisfied.

```ruby
# frozen_string_literal: true

require "hanami/validations"

class EventValidator < Hanami::Validator
  params do
    required(:start_date).value(:date)
  end

  rule(:start_date) do
    key.failure("must be in the future") if value <= Date.today
  end
end

validator = EventValidator.new

result = validator.call(start_date: "foo")
puts result.success? # => false
puts result.errors.to_h # => {:start_date=>["must be a date"]}

result = validator.call(start_date: Date.today)
puts result.success? # => false
puts result.errors.to_h # => {:start_date=>["must be in the future"]}

result = validator.call(start_date: Date.today + 1)
puts result.success? # => true
puts result.to_h # => {:start_date=>#<Date: 2019-07-03 ((2458668j,0s,0n),+0s,2299161j)>}
```

Learn more about rules: https://dry-rb.org/gems/dry-validation/rules/

### Inheritance

Schema and rules validations can be inherited and used by subclasses

```ruby
# frozen_string_literal: true

require "hanami/validations"

class ApplicationValidator < Hanami::Validator
  params do
    optional(:_csrf_token).filled(:string)
  end
end

class SignupValidator < ApplicationValidator
  params do
    required(:user).hash do
      required(:email).filled(:string)
    end
  end
end

validator = SignupValidator.new

result = validator.call(user: { email: "user@hanamirb.test" }, _csrf_token: "abc123")
puts result.success? # => true
puts result.to_h # => {:user=>{:email=>"user@hanamirb.test"}, :_csrf_token=>"abc123"}
```

### Messages

Failure messages can be hardcoded or refer to a message template system.
`hanami-validations` supports natively a default YAML based message template system, or alternatively, `i18n` gem.

We have already seen rule failures set with hardcoded messages, here's an example of how to use keys to refer to interpolated messages.

```ruby
# frozen_string_literal: true

require "hanami/validations"

class ApplicationValidator < Hanami::Validator
  config.messages.top_namespace = "bookshelf"
  config.messages.load_paths << "config/errors.yml"
end
```

In the `ApplicationValidator` there is defined the application namespace (`"bookshelf"`), which is the root of the messages file.
Below that top name, there is the key `errors`. Everything that is nested here is accessible by the validations.

There are two ways to organize messages:

  1. Right below `errors`. This is for **general purposes** error messages (e.g. `bookshelf` => `errors` => `taken`)
  2. Below `errors` => `rules` => name of the attribute => custom key (e.g. `bookshelf` => `errors` => `age` => `invalid`). This is for **specific** messages that affect only a specific attribute.

Our **suggestion** is to start with **specific** messages and see if there is a need to generalize them.

```yaml
# config/errors.yml
en:
  bookshelf:
    errors:
      taken: "oh noes, it's already taken"
      network: "there is a network error (%{code})"
      rules:
        age:
          invalid: "must be greater than 18"
        email:
          invalid: "not a valid email"
```

#### General purpose messages

```ruby
class SignupValidator < ApplicationValidator
  schema do
    required(:username).filled(:string)
  end

  rule(:username) do
    key.failure(:taken) if values[:username] == "jodosha"
  end
end

validator = SignupValidator.new

result = validator.call(username: "foo")
puts result.success? # => true

result = validator.call(username: "jodosha")
puts result.success? # => false
puts result.errors.to_h # => {:username=>["oh noes, it's already taken"]}
```

#### Specific messages

Please note that the failure key used it's the same for both the attributes (`:invalid`), but thanks to the nesting, the library is able to lookup the right message.

```ruby
class SignupValidator < ApplicationValidator
  schema do
    required(:email).filled(:string)
    required(:age).filled(:integer)
  end

  rule(:email) do
    key.failure(:invalid) unless values[:email] =~ /@/
  end

  rule(:age) do
    key.failure(:invalid) if values[:age] < 18
  end
end

validator = SignupValidator.new

result = validator.call(email: "foo", age: 17)
puts result.success? # => false
puts result.errors.to_h # => {:email=>["not a valid email"], :age=>["must be greater than 18"]}
```

#### Extra information

The interpolation mechanism, accepts extra, arbitrary information expressed as a `Hash` (e.g. `code: "123"`)

```ruby
class RefundValidator < ApplicationValidator
  schema do
    required(:refunded_code).filled(:string)
  end

  rule(:refunded_code) do
    key.failure(:network, code: "123") if values[:refunded_code] == "error"
  end
end

validator = RefundValidator.new

result = validator.call(refunded_code: "error")
puts result.success? # => false
puts result.errors.to_h # => {:refunded_code=>["there is a network error (123)"]}
```

Learn more about messages: https://dry-rb.org/gems/dry-validation/messages/

### External dependencies

If the validator needs to plug one or more objects to run the validations, there is a DSL to do so: `:option`.
When the validator is instantiated, the declared dependencies must be passed.

```ruby
# frozen_string_literal: true

require "hanami/validations"

class AddressValidator
  def valid?(value)
    value.match(/Rome/)
  end
end

class DeliveryValidator < Hanami::Validator
  option :address_validator

  schema do
    required(:address).filled(:string)
  end

  rule(:address) do
    key.failure("not a valid address") unless address_validator.valid?(values[:address])
  end
end

validator = DeliveryValidator.new(address_validator: AddressValidator.new)

result = validator.call(address: "foo")
puts result.success? # => false
puts result.errors.to_h # => {:address=>["not a valid address"]}
```

Read more about external dependencies: https://dry-rb.org/gems/dry-validation/external-dependencies/

### Mixin

`hanami-validations` 1.x used to ship a mixin `Hanami::Validations` to be included in classes to provide validation rules.
The 2.x series, still ships this mixin, but it will be probably removed in 3.x.

```ruby
# frozen_string_literal: true

require "hanami/validations"

class UserValidator
  include Hanami::Validations

  validations do
    required(:number).filled(:integer, eql?: 23)
  end
end

result = UserValidator.new(number: 23).validate

puts result.success? # => true
puts result.to_h # => {:number=>23}
puts result.errors.to_h # => {}

result = UserValidator.new(number: 11).validate

puts result.success? # => true
puts result.to_h # => {:number=>21}
puts result.errors.to_h # => {:number=>["must be equal to 23"]}
```

## FAQs
### Uniqueness Validation

Uniqueness validation isn't implemented by `Hanami::Validations` because the context of execution is completely decoupled from persistence.
Please remember that **uniqueness validation is a huge race condition between application and the database, and it doesn't guarantee records uniqueness for real.** To effectively enforce this policy you can use SQL database constraints.

Please read more at: [The Perils of Uniqueness Validations](http://robots.thoughtbot.com/the-perils-of-uniqueness-validations).

If you need to implement it, please use the External dependencies feature (see above).

## Contributing

1. Fork it ( https://github.com/hanami/validations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright © 2014-2019 Luca Guidi – Released under MIT License

This project was formerly known as Lotus (`lotus-validations`).
