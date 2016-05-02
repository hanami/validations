# Hanami::Validations

Validations mixin for Ruby objects

## Status

[![Gem Version](http://img.shields.io/gem/v/hanami-validations.svg)](https://badge.fury.io/rb/hanami-validations)
[![Build Status](http://img.shields.io/travis/hanami/validations/master.svg)](https://travis-ci.org/hanami/validations?branch=master)
[![Coverage](http://img.shields.io/coveralls/hanami/validations/master.svg)](https://coveralls.io/r/hanami/validations)
[![Code Climate](http://img.shields.io/codeclimate/github/hanami/validations.svg)](https://codeclimate.com/github/hanami/validations)
[![Dependencies](http://img.shields.io/gemnasium/hanami/validations.svg)](https://gemnasium.com/hanami/validations)
[![Inline Docs](http://inch-ci.org/github/hanami/validations.svg)](http://inch-ci.org/github/hanami/validations)

## Contact

* Home page: http://hanamirb.org
* Mailing List: http://hanamirb.org/mailing-list
* API Doc: http://rdoc.info/gems/hanami-validations
* Bugs/Issues: https://github.com/hanami/validations/issues
* Support: http://stackoverflow.com/questions/tagged/hanami
* Chat: http://chat.hanamirb.org

## Rubies

__Hanami::Validations__ supports Ruby (MRI) 2+ and JRuby 9.0.5.0+.

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

It works with input hashes and lets us to define a set of validation rules **for each** key/value pair. These rules are wrapped by lambdas that can only return `true` or `false` to state that a specific key is valid or not. To do that, we translate business requirements into predicates that are chained together with Ruby _boolean logic_ operators (eg. `&&`).

Think of a signup form. We need to ensure data integrity for the  `name` field with the following rules. It has to be: present **and** a string **and** its size must be greater than 3 chars, but lesser than 64. Here’s the code, **read it aloud** and notice how it perfectly expresses our needs for `name`.

```ruby
class Signup
  include Hanami::Validations
  validates(:name) { present? && str? && size?(3..64) }
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
         A name must be present  and be a string and its size must be included between 3 and 64.
            👇            👇     👇       👇    👇      👇                           👇    👇
validates(:name)      { present? &&       str?   &&      size?                        (3 ..  64) }

```

Now, I hope you’ll never format code like that, but in this case, that formatting serves well our purpose to show how Ruby’s  simplicity helps to define complex rules with no effort.

From a high level perspective, we can tell that input data for `name` is _valid_ only if **all** the requirements are satisfied. That’s because we used `&&`, but we can use whatever logic we want. **Remember, they are just lambdas**.

```ruby
validates(:name) { true }
validates(:name) { 1 == 1 }
validates(:name) { 0 > 1 || 0 < 1 }
```

These examples above are all acceptable, but not really useful. 
We need something applicable to our real world projects.

### Predicates

To meet our needs, `Hanami::Validations` has an extensive collection of **built-in** predicates. **A predicate is the expression of a business requirement** (e.g. size greater than). The chain of several predicates determines if input data is valid or not.

We already met _presence_ and _size_, now let’s introduce the rest of them. They capture **common use cases with web forms**.

#### Acceptance

This predicate is useful to verify if a form check-box was checked by an user.

```ruby
validates(:terms_of_service) { accepted? }
```

_Truthy_ values are evaluated according to the following rules.

| value         | valid |
|---------------|-------|
| `false`       | ✗     |
| `true`        | ✔︎     |
| `nil`         | ✗     |
| `""`          | ✗     |
| `"0"`         | ✗     |
| `"1"`         | ✔︎     |
| other strings | ✗     |
| `0`           | ✗     |
| `1`           | ✔︎     |
| other numbers | ✗     |
| other objects | ✔︎     |

#### All?

It checks if **all** the elements of an array satisfy a rule inside the given block.

```ruby
validates(:numbers) { all? {|n| n % 2 == 0 } }
```

Similarly to Ruby’s `Enumerable#all?` we can pass a `Proc` expressed as a `Symbol`. The code above can be rewritten as:

```ruby
validates(:numbers) { all?(&:even?) }
```

NOTE: This works because `Integer` responds to `#even?`.

#### Any?

This predicate is like `#all?`: it verifies one or more conditions (inside a block) on the elements of an array. But to make it to pass, **at least one element** must satisfy the conditions.

```ruby
validates(:numbers) { any?(&:even?) }
```

If it receives at least one even number, it passes the check.

#### Confirmation

This is designed to check if pairs of web form fields have the same value. One wildly popular example is _password confirmation_ (hence the name).

```ruby
validates(:password) { confirmed? }
```

It is valid if the input has `password` and `password_confirmation` keys with the same exact value.

⚠ **CONVENTION:** For a given key `password`, the _confirmation_ predicate expects another key `password_confirmation`. Easy to tell, it’s the concatenation of the original key with the `_confirmation` suffix. Their values must be equal. ⚠

#### Emptiness

It checks if the given value is empty or not. It is designed to works with strings and collections (array and hash).

```ruby
validates(:tags) { empty? }
```

#### Equality

This predicate tests if the input is equal to a given value.

```ruby
validates(:magic_number) { eql?(23) }
```

Ruby types are respected: `23` (an integer) is only equal to `23`, and not to `"23"` (a string). See _Type Safety_ section.

#### Exclusion

It checks if the input is **not** included by a given collection. This collection can be an array, a set, a range or any object that responds to `#include?`.

```ruby
validates(:genre) { exclude?(%w(pop dance)) }
```

#### Format

This is a predicate that works with a regular expression to match it against data input.

```ruby
require 'uri'
HTTP_FORMAT = URI.regexp(%w(http https))

validates(:url) { format?(HTTP_FORMAT) }
```

#### Greater Than

This predicate works with numbers to check if input is **greater than** a given threshold.

```ruby
validates(:age) { gt?(18) }
```

#### Greater Than Equal

This is an _open boundary_ variation of `gt?`. It checks if an input is **greater than or equal** of a given number.

```ruby
validates(:age) { gteq?(19) }
```

#### Inclusion

This predicate is the opposite of `#exclude?`: it verifies if the input is **included** in the given collection.

```ruby
validates(:genre) { include?(%w(rock folk)) }
```

#### Less Than

This is the complement of `#gt?`: it checks for **less than** numbers.

```ruby
validates(:age) { lt?(7) }
```

#### Less Than Equal

Similarly to `#gteq?`, this is the _open bounded_ version of `#lt?`: an input is valid if it’s **less than or equal** to a number.

```ruby
validates(:age) { lteq?(6) }
```

#### Nil

This verifies if the given input is `nil`. Blank strings (`""`) won’t pass this test and return `false`.

```ruby
validates(:location) { nil? }
```

#### Presence

It’s a predicate that ensures data input is **not** `nil` or blank (`""`) or empty (in case we expect a collection).

```ruby
validates(:name) { present? }      # string
validates(:languages) { present? } # collection
```

#### Size

It checks if the size of input data is: a) exactly the same of a given quantity or b) it falls into a range.

```ruby
validates(:two_factor_auth_code) { size?(6) }     # exact
validates(:password)             { size?(8..32) } # range
```

The check works with strings and collections.

```ruby
validates(:answers) { size?(2) } # only 2 answers are allowed
```

This predicate works with objects that respond to `#size`. Until now we have seen strings and arrays being analysed by this validation, but there is another interesting usage: files.

When a user uploads a file, the web server sets an instance of `Tempfile`, which responds to `#size`. That means we can validate the weight in bytes of file uploads.

```ruby
MEGABYTE = 1024 ** 2

validates(:avatar) { size?(1..(5 * MEGABYTE)) }
```

#### Current Value

If we want to access to the current value, we have the `#value` predicate.

```ruby
validates(:name) { value == "Luca" }
```

#### Other Values

If we need to validate a key according to the value of another key, we can use a special predicate `#val`. As an example, let’s rewrite _password confirmation_ rule with it.

```ruby
validates(:password) { eql?(val(:password_confirmation)) }
```

### Custom Predicates

We have seen that _boolean logic_ is a powerful way to define rules. On top of it, there are built-in predicates as an expressive tool to get our job done with common use cases.

But what if our case is not common?

Sure, we can always rely on _boolean logic_, but we have seen that is not elegant as predicates are. Look at the following example:

```ruby
require 'bigdecimal'

validates(:num) do
  actual = BigDecimal.new(value)

  big1 = (5 * (actual**2) + 4).sqrt(0)
  big2 = (5 * (actual**2) - 4).sqrt(0)

  (big1 == big1.round || big2 == big2.round)
end
```

What that is about? At the first glance we can’t recognise which business rule we have coded.

Spoiler alert: we’re checking if `num` belongs to the Fibonacci Sequence.

Because there isn’t a `#fibonacci?` built-in predicate, we have used _boolean logic_, but again, it’s a **cryptic** snippet that we can’t easily digest. To solve this problem, we can define a **custom predicate**, with the purpose of making it readable and reusable.

```ruby
require 'bigdecimal'

predicate :fibonacci? do |actual|
  actual = BigDecimal.new(actual)

  big1 = (5 * (actual**2) + 4).sqrt(0)
  big2 = (5 * (actual**2) - 4).sqrt(0)

  (big1 == big1.round || big2 == big2.round)
end

validates(:num) { fibonacci? }
```

Custom predicates accept a Proc, similarly to `#all?` and `#any?` we can use a special symbol syntax.

```ruby
predicate(:positive?, &:positive?)

validates(:num) { positive? }
```

NOTE: That `&:positive?` part is a reference to `Integer#positive?`.

### Type Safety

At this point, we need to explicitly tell something really important about built-in predicates. Each of them have expectations about the methods that an input is able to respond to.

Why this is so important? Because if we try to invoke a method on the input we’ll get a `NoMethodError` if the input doesn’t respond to it. Which isn’t nice, right?

Before to use a predicate, we want to ensure that the input is an instance of the expected type. Let’s introduce another new predicate for our need: `#type?`.

```ruby
validates(:age) { type?(Integer) && gteq?(18) }
```

It takes the input and tries to coerce it. If it fails, the execution stops. If it succeed, the subsequent predicates can trust `#type?` and be sure that the input is an integer.

**We suggest to use `#type?` at the beginning of the validations block. This _type safety_ policy is crucial to prevent runtime errors.**

`Hanami::Validations` supports the most common Ruby types:

  * `Array` (aliased as `array?`)
  * `BigDecimal` (aliased as `decimal?`)
  * `Boolean` (aliased as `bool?`)
  * `Date` (aliased as `date?`)
  * `DateTime` (aliased as `datetime?`)
  * `Float` (aliased as `float?`)
  * `Hash` (aliased as `hash?`)
  * `Integer` (aliased as `int?`)
  * `String` (aliased as `str?`)
  * `Time` (aliased as `time?`)

For each supported type, there a convenient predicate that acts as an alias. For instance, the two lines of code below are **equivalent**.

```ruby
validates(:age) { type?(Integer) }
validates(:age) { int? }
```

### Custom Types

Once again, the framework supports conventional scenarios, but it’s open of extension in case we need to customise it. This is true for types too: we can pass any class as argument of `#type?`.

```ruby
require 'uri'

class Url
  BLANK_STRING = /\A[[:space:]]*\z/

  def initialize(url)
    check!(url)
    @url = URI.parse(url.to_s)
  end

  def to_str
    @url.to_s
  end
  
  private
  
  def check!(url)
    raise ArgumentError if url.nil? ||
      url.to_s.match(BLANK_STRING)
  end
end
```

We have defined a new type (`Url`) and we’re gonna use it with `#type?`.

```ruby
validates(:website) { type?(Url) }
```

There are a few exceptions that `Url` may raise when initialised, but **none of them will be raised in case of invalid input**. What the framework does in cases like this is to **suppress the exceptions and return a failure**.

We can be trust `#type?` to do the right thing: **try to coerce or fail safely**. That’s why we should use it.

### Nested Input Data

While we’re building complex web forms, we may find comfortable to organise data in a hierarchy of cohesive input fields. For instance, all the fields concerning a customer, may have the `customer` prefix. To reflect this arrangement on the server side, we can group keys.

```ruby
group(:customer) do
  validates(:email) { … }
  validates(:name)  { … }
  # other validations …
end
```

Groups can be **deeply nested**, without any limitation.

```ruby
group(:customer) do
  # other validations …
  
  group(:address) do
    validates(:street) { … }
    # other address validations …
  end
end
```

### Composition

Until now, we have seen only small snippets to show specific features. That really close view prevents us to see the big picture of complex real world projects.

As the code base grows, it’s a good practice to DRY validation rules.

```ruby
class AddressValidator
  include Hanami::Validations
  
  validates(:street) { … }
end
```

This validator can be reused by other validators.

```ruby
class CustomerValidator
  include Hanami::Validations
  
  validates(:email) { … }
  validates(:address).with(AddressValidator)
end
```

Again, there is no limit to the nesting levels.

```ruby
class OrderValidator
  include Hanami::Validations
  
  validates(:number) { … }
  validates(:customer).with(CustomerValidator)
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

Another fundamental role that `Hanami::Validations` plays in the architecture of our projects is input whitelisting.
For security reasons, we want to allow known keys to come in and reject everything else.

This process happens when we invoke `#validate`.
Allowed keys are the ones defined with `.validates`.

### Result

When we trigger the validation process with `#validate`, we get a result object in return. It’s able to tell if it’s successful, which rules the input data has violated and an output data bag.

```ruby
result = OrderValidator.new({}).validate
result.success? # => false
result.errors.for(:"customer.address.city")
  # => [
    #<Hanami::Validations::Error:0x007fcfcac3d498
    @key=:"customer.address.city",
    @predicate=:present?,
    @expected=nil,
    @actual=nil>
  ]
```

#### Errors

`result.errors` returns a **flat** set of validation errors. We can use `#for` to access a collection of errors for a specific key. Nested keys are separated by a dot.

Each error carries on informations about a single rule violation.

```ruby
error = result.errors.for(:number).first
error.key       # => :number
error.predicate # => :int?
error.expected  # => Integer
error.actual    # => "foo"
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

## FAQs
### Uniqueness Validation

Uniqueness validations aren't implemented because this library doesn't deal with persistence.
The other reason is that this isn't an effective way to ensure uniqueness of a value in a database.

Please read more at: [The Perils of Uniqueness Validations](http://robots.thoughtbot.com/the-perils-of-uniqueness-validations).

## Acknowledgements

Thanks to [Piotr Solnica](https://github.com/solnic), [Tim Riley](https://github.com/timriley), and [Andy Holland](https://github.com/AMHOL) for [dry-validation](http://dry-rb.org/gems/dry-validation), which it has been source of strong inspiration for `hanami-validations`. Thanks to [Fran Worley](https://github.com/fran-worley) for her help in [dry-rb chat](https://gitter.im/dry-rb/chat).

## Contributing

1. Fork it ( https://github.com/hanami/validations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright © 2014-2016 Luca Guidi – Released under MIT License

This project was formerly known as Lotus (`lotus-validations`).
