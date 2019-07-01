# Hanami::Validations

Validations mixin for Ruby objects

## Status

[![Gem Version](https://badge.fury.io/rb/hanami-validations.svg)](https://badge.fury.io/rb/hanami-validations)
[![TravisCI](https://travis-ci.org/hanami/validations.svg?branch=master)](https://travis-ci.org/hanami/validations)
[![CircleCI](https://circleci.com/gh/hanami/validations/tree/master.svg?style=svg)](https://circleci.com/gh/hanami/validations/tree/master)
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

__Hanami::Validations__ supports Ruby (MRI) 2.3+ and JRuby 9.1.5.0+.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-validations'
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

`Hanami::Validations` is a mixin that, once included by an object, adds lightweight set of validations to it.

It works with input hashes and lets us to define a set of validation rules **for each** key/value pair. These rules are wrapped by lambdas (or special DSL) that check the input for a specific key to determine if it's valid or not. To do that, we translate business requirements into predicates that are chained together with Ruby _faux boolean logic_ operators (eg. `&` or `|`).

Think of a signup form. We need to ensure data integrity for the  `name` field with the following rules. It is required, it has to be: filled **and** a string **and** its size must be greater than 3 chars, but lesser than 64. Here’s the code, **read it aloud** and notice how it perfectly expresses our needs for `name`.

```ruby
class Signup
  include Hanami::Validations

  validations do
    required(:name) { filled? & str? & size?(3..64) }
  end
end

result = Signup.new(name: "Luca").validate
result.success? # => true
```

There is more that `Hanami::Validations` can do: **type safety**, **composition**, **complex data structures**, **built-in and custom predicates**.

But before to dive into advanced topics, we need to understand the basics of _boolean logic_.

### Boolean Logic

When we check data, we expect only two outcomes: an input can be valid or not. No grey areas, nor fuzzy results. It’s white or black, 1 or 0, `true` or `false` and _boolean logic_ is the perfect tool to express these two states. Indeed, a Ruby _boolean expression_ can only return `true` or `false`.

To better recognise the pattern, let’s get back to the example above. This time we will map the natural language rules with programming language rules.

```
        A name must be filled  and be a string and its size must be included between 3 and 64.
           👇            👇    👇       👇    👇      👇                           👇    👇
required(:name)      { filled?  &       str?   &      size?                         (3 ..  64) }

```

Now, I hope you’ll never format code like that, but in this case, that formatting serves well our purpose to show how Ruby’s  simplicity helps to define complex rules with no effort.

From a high level perspective, we can tell that input data for `name` is _valid_ only if **all** the requirements are satisfied. That’s because we used `&`.

#### Logic Operators

We support four logic operators:

  * `&` (aliased as `and`) for _conjunction_
  * `|` (aliased as `or`) for _disjunction_
  * `>` (aliased as `then`) for _implication_
  * `^` (aliased as `xor`) for _exclusive disjunction_

#### Context Of Execution

**Please notice that we used `&` over Ruby's `&&` keyword.**
That's because the context of execution of these validations isn't a plain lambda, but something richer.

For real world projects, we want to support common scenarios without the need of reinventing the wheel ourselves. Scenarios like _password confirmation_, _size check_ are already prepackaged with `Hanami::Validations`.


⚠ **For this reason, we don't allow any arbitrary Ruby code to be executed, but only well defined predicates.** ⚠

### Predicates

To meet our needs, `Hanami::Validations` has an extensive collection of **built-in** predicates. **A predicate is the expression of a business requirement** (e.g. _size greater than_). The chain of several predicates determines if input data is valid or not.

We already met `filled?` and `size?`, now let’s introduce the rest of them. They capture **common use cases with web forms**.

### Array

It checks if the the given value is an array, and iterates through its elements to perform checks on each of them.

```ruby
required(:codes) { array? { each { int? } } }
```

This example checks if `codes` is an array and if all the elements are integers, whereas the following example checks there are a minimum of 2 elements and all elements are strings.

```ruby
required(:codes) { array? { min_size?(2) & each { str? } } }
```

#### Emptiness

It checks if the given value is empty or not. It is designed to works with strings and collections (array and hash).

```ruby
required(:tags) { empty? }
```

#### Equality

This predicate tests if the input is equal to a given value.

```ruby
required(:magic_number) { eql?(23) }
```

Ruby types are respected: `23` (an integer) is only equal to `23`, and not to `"23"` (a string). See _Type Safety_ section.

#### Exclusion

It checks if the input is **not** included by a given collection. This collection can be an array, a set, a range or any object that responds to `#include?`.

```ruby
required(:genre) { excluded_from?(%w(pop dance)) }
```

#### Format

This is a predicate that works with a regular expression to match it against data input.

```ruby
require 'uri'
HTTP_FORMAT = URI.regexp(%w(http https))

required(:url) { format?(HTTP_FORMAT) }
```

#### Greater Than

This predicate works with numbers to check if input is **greater than** a given threshold.

```ruby
required(:age) { gt?(18) }
```

#### Greater Than Equal

This is an _open boundary_ variation of `gt?`. It checks if an input is **greater than or equal** of a given number.

```ruby
required(:age) { gteq?(19) }
```

#### Inclusion

This predicate is the opposite of `#exclude?`: it verifies if the input is **included** in the given collection.

```ruby
required(:genre) { included_in?(%w(rock folk)) }
```

#### Less Than

This is the complement of `#gt?`: it checks for **less than** numbers.

```ruby
required(:age) { lt?(7) }
```

#### Less Than Equal

Similarly to `#gteq?`, this is the _open bounded_ version of `#lt?`: an input is valid if it’s **less than or equal** to a number.

```ruby
required(:age) { lteq?(6) }
```

#### Filled

It’s a predicate that ensures data input is filled, that means **not** `nil` or blank (`""`) or empty (in case we expect a collection).

```ruby
required(:name) { filled? }      # string
required(:languages) { filled? } # collection
```

#### Minimum Size

This verifies that the size of the given input is at least of the specified value.

```ruby
required(:password) { min_size?(12) }
```

#### Maximum Size

This verifies that the size of the given input is at max of the specified value.

```ruby
required(:name) { max_size?(128) }
```

#### None

This verifies if the given input is `nil`. Blank strings (`""`) won’t pass this test and return `false`.

```ruby
required(:location) { none? }
```

#### Size

It checks if the size of input data is: a) exactly the same of a given quantity or b) it falls into a range.

```ruby
required(:two_factor_auth_code) { size?(6) }     # exact
required(:password)             { size?(8..32) } # range
```

The check works with strings and collections.

```ruby
required(:answers) { size?(2) } # only 2 answers are allowed
```

This predicate works with objects that respond to `#size`. Until now we have seen strings and arrays being analysed by this validation, but there is another interesting usage: files.

When a user uploads a file, the web server sets an instance of `Tempfile`, which responds to `#size`. That means we can validate the weight in bytes of file uploads.

```ruby
MEGABYTE = 1024 ** 2

required(:avatar) { size?(1..(5 * MEGABYTE)) }
```

### Custom Predicates

We have seen that built-in predicates as an expressive tool to get our job done with common use cases.

But what if our case is not common? We can define our own custom predicates.

#### Inline Custom Predicates

If we are facing a really unique validation that don't need to be reused across our code, we can opt for an inline custom predicate:

```ruby
require 'hanami/validations'

class Signup
  include Hanami::Validations

  predicate :url?, message: 'must be an URL' do |current|
    # ...
  end

  validations do
    required(:website) { url? }
  end
end
```

#### Global Custom Predicates

If our goal is to share common used custom predicates, we can include them in a module to use in all our validators:

```ruby
require 'hanami/validations'

module MyPredicates
  include Hanami::Validations::Predicates

  self.messages_path = 'config/errors.yml'

  predicate(:email?) do |current|
    current.match(/.../)
  end
end
```

We have defined a module `MyPredicates` with the purpose to share its custom predicates with all the validators that need them.

```ruby
require 'hanami/validations'
require_relative 'my_predicates'

class Signup
  include Hanami::Validations
  predicates MyPredicates

  validations do
    required(:email) { email? }
  end
end
```

### Required and Optional keys

HTML forms can have required or optional fields. We can express this concept with two methods in our validations: `required` (which we already met in previous examples), and `optional`.

```ruby
require 'hanami/validations'

class Signup
  include Hanami::Validations

  validations do
    required(:email)    { ... }
    optional(:referral) { ... }
  end
end
```

### Type Safety

At this point, we need to explicitly tell something really important about built-in predicates. Each of them have expectations about the methods that an input is able to respond to.

Why this is so important? Because if we try to invoke a method on the input we’ll get a `NoMethodError` if the input doesn’t respond to it. Which isn’t nice, right?

Before to use a predicate, we want to ensure that the input is an instance of the expected type. Let’s introduce another new predicate for our need: `#type?`.

```ruby
required(:age) { type?(Integer) & gteq?(18) }
```

It takes the input and tries to coerce it. If it fails, the execution stops. If it succeed, the subsequent predicates can trust `#type?` and be sure that the input is an integer.

**We suggest to use `#type?` at the beginning of the validations block. This _type safety_ policy is crucial to prevent runtime errors.**

`Hanami::Validations` supports the most common Ruby types:

  * `Array` (aliased as `array?`)
  * `BigDecimal` (aliased as `decimal?`)
  * `Boolean` (aliased as `bool?`)
  * `Date` (aliased as `date?`)
  * `DateTime` (aliased as `date_time?`)
  * `Float` (aliased as `float?`)
  * `Hash` (aliased as `hash?`)
  * `Integer` (aliased as `int?`)
  * `String` (aliased as `str?`)
  * `Time` (aliased as `time?`)

For each supported type, there a convenient predicate that acts as an alias. For instance, the two lines of code below are **equivalent**.

```ruby
required(:age) { type?(Integer) }
required(:age) { int? }
```

### Macros

Rule composition with blocks is powerful, but it can become verbose.
To reduce verbosity, `Hanami::Validations` offers convenient _macros_ that are internally _expanded_ (aka interpreted) to an equivalent _block expression_

#### Filled

To use when we expect a value to be filled:

```ruby
# expands to
# required(:age) { filled? }

required(:age).filled
```

```ruby
# expands to
# required(:age) { filled? & type?(Integer) }

required(:age).filled(:int?)
```

```ruby
# expands to
# required(:age) { filled? & type?(Integer) & gt?(18) }

required(:age).filled(:int?, gt?: 18)
```

In the examples above `age` is **always required** as value.

#### Maybe

To use when a value can be nil:

```ruby
# expands to
# required(:age) { none? | int? }

required(:age).maybe(:int?)
```

In the example above `age` can be `nil`, but if we send the value, it **must** be an integer.

#### Each

To use when we want to apply the same validation rules to all the elements of an array:

```ruby
# expands to
# required(:tags) { array? { each { str? } } }

required(:tags).each(:str?)
```

In the example above `tags` **must** be an array of strings.


#### Confirmation

This is designed to check if pairs of web form fields have the same value. One wildly popular example is _password confirmation_.

```ruby
required(:password).filled.confirmation
```

It is valid if the input has `password` and `password_confirmation` keys with the same exact value.

⚠ **CONVENTION:** For a given key `password`, the _confirmation_ predicate expects another key `password_confirmation`. Easy to tell, it’s the concatenation of the original key with the `_confirmation` suffix. Their values must be equal. ⚠

### Forms

An important precondition to check before to implement a validator is about the expected input.
When we use validators for already preprocessed data it's safe to use basic validations from `Hanami::Validations` mixin.

If the data is coming directly from user input via a HTTP form, it's advisable to use `Hanami::Validations::Form` instead.
**The two mixins have the same API, but the latter is able to do low level input preprocessing specific for forms**. For instance, blank inputs are casted to `nil` in order to avoid blank strings in the database.

### Rules

Predicates and macros are tools to code validations that concern a single key like `first_name` or `email`.
If the outcome of a validation depends on two or more attributes we can use _rules_.

Here's a practical example: a job board.
We want to validate the form of the job creation with some mandatory fields: `type` (full time, part-time, contract), `title` (eg. Developer), `description`, `company` (just the name) and a `website` (which is optional).
An user must specify the location: on-site or remote. If it's on site, they must specify the `location`, otherwise they have to tick the checkbox for `remote`.

Here's the code:

```ruby
class CreateJob
  include Hanami::Validations::Form

  validations do
    required(:type).filled(:int?, included_in?: [1, 2, 3])

    optional(:location).maybe(:str?)
    optional(:remote).maybe(:bool?)

    required(:title).filled(:str?)
    required(:description).filled(:str?)
    required(:company).filled(:str?)

    optional(:website).filled(:str?, format?: URI.regexp(%w(http https)))

    rule(location_presence: [:location, :remote]) do |location, remote|
      (remote.none? | remote.false?).then(location.filled?) &
        remote.true?.then(location.none?)
    end
  end
end
```

We specify a rule with `rule` method, which takes an arbitrary name and an array of preconditions.
Only if `:location` and `:remote` are valid according to their validations described above, the `rule` block is evaluated.

The block yields the same exact keys that we put in the precondintions.
So for `[:location, :remote]` it will yield the corresponding values, bound to the `location` and `remote` variables.

We can use these variables to define the rule. We covered a few cases:

  * If `remote` is missing or false, then `location` must be filled
  * If `remote` is true, then `location` must be omitted

### Nested Input Data

While we’re building complex web forms, we may find comfortable to organise data in a hierarchy of cohesive input fields. For instance, all the fields related to a customer, may have the `customer` prefix. To reflect this arrangement on the server side, we can group keys.

```ruby
validations do
  required(:customer).schema do
    required(:email) { … }
    required(:name)  { … }
    # other validations …
  end
end
```

Groups can be **deeply nested**, without any limitation.

```ruby
validations do
  required(:customer).schema do
    # other validations …

    required(:address).schema do
      required(:street) { … }
      # other address validations …
    end
  end
end
```

### Composition

Until now, we have seen only small snippets to show specific features. That really close view prevents us to see the big picture of complex real world projects.

As the code base grows, it’s a good practice to DRY validation rules.

```ruby
class AddressValidator
  include Hanami::Validations

  validations do
    required(:street) { … }
  end
end
```

This validator can be reused by other validators.

```ruby
class CustomerValidator
  include Hanami::Validations

  validations do
    required(:email) { … }
    required(:address).schema(AddressValidator)
  end
end
```

Again, there is no limit to the nesting levels.

```ruby
class OrderValidator
  include Hanami::Validations

  validations do
    required(:number) { … }
    required(:customer).schema(CustomerValidator)
  end
end
```

In the end, `OrderValidator` is able to validate a complex data structure like this:

```ruby
{
  number: "123",
  customer: {
    email: "user@example.com",
    address: {
      city: "Rome"
    }
  }
}
```

### Whitelisting

Another fundamental role that validators plays in the architecture of our projects is input whitelisting.
For security reasons, we want to allow known keys to come in and reject everything else.

This process happens when we invoke `#validate`.
Allowed keys are the ones defined with `.required`.

**Please note that whitelisting is only available for `Hanami::Validations::Form` mixin.**

### Result

When we trigger the validation process with `#validate`, we get a result object in return. It’s able to tell if it’s successful, which rules the input data has violated and an output data bag.

```ruby
result = OrderValidator.new({}).validate
result.success? # => false
```

#### Messages

`result.messages` returns a nested set of validation error messages.

Each error carries on informations about a single rule violation.

```ruby
result.messages.fetch(:number)   # => ["is missing"]
result.messages.fetch(:customer) # => ["is missing"]
```

#### Output

`result.output` is a `Hash` which is the result of whitelisting and coercions. It’s useful to pass it do other components that may want to persist that data.

```ruby
{
  "number"  => "123",
  "unknown" => "foo"
}
```

If we receive the input above, `output` will look like this.

```ruby
result.output
  # => { :number => 123 }
```

We can observe that:

  * Keys are _symbolized_
  * Only whitelisted keys are included
  * Data is coerced

### Error Messages

To pick the right error message is crucial for user experience.
As usual `Hanami::Validations` comes to the rescue for most common cases and it leaves space to customization of behaviors.

We have seen that builtin predicates have default messages, while [inline predicates](#inline-custom-predicates) allow to specify a custom message via the `:message` option.

```ruby
class SignupValidator
  include Hanami::Validations

  predicate :email?, message: 'must be an email' do |current|
    # ...
  end

  validations do
    required(:email).filled(:str?, :email?)
    required(:age).filled(:int?, gt?: 18)
  end
end

result = SignupValidator.new(email: 'foo', age: 1).validate

result.success?               # => false
result.messages.fetch(:email) # => ['must be an email']
result.messages.fetch(:age)   # => ['must be greater than 18']
```

#### Configurable Error Messages

Inline error messages are ideal for quick and dirty development, but we suggest to use an external YAML file to configure these messages:

```yaml
# config/messages.yml
en:
  errors:
    email?: "must be an email"
```

To be used like this:

```ruby
class SignupValidator
  include Hanami::Validations
  messages_path 'config/messages.yml'

  predicate :email? do |current|
    # ...
  end

  validations do
    required(:email).filled(:str?, :email?)
    required(:age).filled(:int?, gt?: 18)
  end
end

```


#### Custom Error Messages

In the example above, the failure message for age is fine: `"must be greater than 18"`, but how to tweak it? What if we need to change into something diffent? Again, we can use the YAML configuration file for our purpose.

```yaml
# config/messages.yml
en:
  errors:
    email?: "must be an email"

    rules:
      signup:
        age:
          gt?: "must be an adult"

```

Now our validator is able to look at the right error message.

```ruby
result = SignupValidator.new(email: 'foo', age: 1).validate

result.success?             # => false
result.messages.fetch(:age) # => ['must be an adult']
```

##### Custom namespace

⚠ **CONVENTION:** For a given validator named `SignupValidator`, the framework will look for `signup` translation key. ⚠

If for some reason that doesn't work for us, we can customize the namespace:

```ruby
class SignupValidator
  include Hanami::Validations

  messages_path 'config/messages.yml'
  namespace     :my_signup

  # ...
end
```

The new namespace should be used in the YAML file too.

```yaml
# config/messages.yml
en:
  # ...
    rules:
      my_signup:
        age:
          gt?: "must be an adult"

```

#### Internationalization (I18n)

If your project already depends on `i18n` gem, `Hanami::Validations` is able to look at the translations defined for that gem and to use them.


```ruby
class SignupValidator
  include Hanami::Validations

  messages :i18n

  # ...
end
```

```yaml
# config/locales/en.yml
en:
  errors:
    signup:
      # ...
```

## FAQs
### Uniqueness Validation

Uniqueness validation isn't implemented by `Hanami::Validations` because the context of execution is completely decoupled from persistence.
Please remember that **uniqueness validation is a huge race condition between application and the database, and it doesn't guarantee records uniqueness for real.** To effectively enforce this policy you can use SQL database constraints.

Please read more at: [The Perils of Uniqueness Validations](http://robots.thoughtbot.com/the-perils-of-uniqueness-validations).

## Acknowledgements

Thanks to [dry-rb](http://dry-rb.org) Community for their priceless support. ❤️
`hanami-validations` uses [dry-validation](http://dry-rb.org/gems/dry-validation) as powerful low-level engine.

## Contributing

1. Fork it ( https://github.com/hanami/validations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright © 2014-2017 Luca Guidi – Released under MIT License

This project was formerly known as Lotus (`lotus-validations`).
