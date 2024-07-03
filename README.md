# Hanami::Validations

Internal support gem for `Hanami::Action` params validation.

## Status

[![Gem Version](https://badge.fury.io/rb/hanami-validations.svg)](https://badge.fury.io/rb/hanami-validations)
[![CI](https://github.com/hanami/validations/actions/workflows/ci.yml/badge.svg)](https://github.com/hanami/validations/actions?query=workflow%3Aci+branch%3Amain)
[![Depfu](https://badges.depfu.com/badges/af6c6be539d9d587c7541ae7a013c9ff/overview.svg)](https://depfu.com/github/hanami/validations?project=Bundler)

## Contact

* Home page: http://hanamirb.org
* Community: http://hanamirb.org/community
* Guides: https://guides.hanamirb.org
* Mailing List: http://hanamirb.org/mailing-list
* API Doc: http://rubydoc.info/gems/hanami-validations
* Bugs/Issues: https://github.com/hanami/validations/issues
* Chat: http://chat.hanamirb.org

## Installation

__Hanami::Validations__ supports Ruby (MRI) 3.1+

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

Installing hanami-validations enables support for `params` validation in
[hanami-controller][controller]’s `Hanami::Action` classes.

```ruby
class Signup < Hanami::Action
  params do
    required(:first_name)
    required(:last_name)
    required(:email)
  end

  def handle(req, *)
    puts req.params.class            # => Signup::Params
    puts req.params.class.superclass # => Hanami::Action::Params

    puts req.params[:first_name]     # => "Luca"
    puts req.params[:admin]          # => nil
  end
end
```

See [hanami-controller][controller] for more detail on params validation.

[controller]: http://github.com/hanami/controller

## Contributing

1. Fork it ( https://github.com/hanami/validations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright © 2014–2024 Hanami Team – Released under MIT License
