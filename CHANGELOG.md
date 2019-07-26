# Hanami::Validations
Validations mixin for Ruby objects

## v1.3.4 - 2019-07-26
### Fixed
- [Luca Guidi] Ensure to load i18n backend (including `i18n` gem), when messages engine is `:i18n`

## v1.3.3 - 2019-01-31
### Fixed
- [Luca Guidi] Depend on `dry-validation` `~> 0.11`, `< 0.12`
- [Luca Guidi] Depend on `dry-logic` `~> 0.4.2`, `< 0.5`

## v1.3.2 - 2019-01-30
### Fixed
- [Luca Guidi] Depend on `dry-validation` `~> 0.11.2`, `< 0.12` in order to skip non compatible `dry-logic` `0.5.0`

## v1.3.1 - 2019-01-18
### Added
- [Luca Guidi] Official support for Ruby: MRI 2.6
- [Luca Guidi] Support `bundler` 2.0+

## v1.3.0 - 2018-10-24

## v1.3.0.beta1 - 2018-08-08
### Added
- [Luca Guidi] Official support for JRuby 9.2.0.0

## v1.2.2 - 2018-06-05
### Fixed
- [Luca Guidi] Revert dependency to `dry-validation` to `~> 0.11`, `< 0.12`

## v1.2.1 - 2018-06-04
### Fixed
- [Luca Guidi] Bump dependency to `dry-validation` to `~> 0.12`

## v1.2.0 - 2018-04-11

## v1.2.0.rc2 - 2018-04-06

## v1.2.0.rc1 - 2018-03-30

## v1.2.0.beta2 - 2018-03-23

## v1.2.0.beta1 - 2018-02-28
### Added
- [Luca Guidi] Official support for Ruby: MRI 2.5

## v1.1.0 - 2017-10-25

## v1.1.0.rc1 - 2017-10-16

## v1.1.0.beta3 - 2017-10-04

## v1.1.0.beta2 - 2017-10-03

## v1.1.0.beta1 - 2017-08-11

## v1.0.0 - 2017-04-06

## v1.0.0.rc1 - 2017-03-31

## v1.0.0.beta2 - 2017-03-17

## v1.0.0.beta1 - 2017-02-14
### Added
- [Luca Guidi] Official support for Ruby: MRI 2.4

### Fixed
- [Luca Guidi] Don't let inline predicates to discard other YAML error messages

## v0.7.1 - 2016-11-18
### Fixed
- [Luca Guidi] Ensure custom validators to work with concrete classes with name

## v0.7.0 - 2016-11-15
### Changed
- [Luca Guidi] Official support for Ruby: MRI 2.3+ and JRuby 9.1.5.0+

## v0.6.0 - 2016-07-22
### Added
- [Luca Guidi] Predicates syntax
- [Luca Guidi] Custom predicates
- [Luca Guidi] Inline predicates
- [Luca Guidi] Shared predicates
- [Luca Guidi] High level rules
- [Luca Guidi] Error messages with I18n support (`i18n` gem)
- [Luca Guidi] Introduced `Hanami::Validations#validate`, which returns a result object.
- [Luca Guidi] Introduced `Hanami::Validations::Form` mixin, which must be used when input comes from HTTP params or web forms.

### Fixed
– [Luca Guidi] Ensure to threat blank values as `nil`

### Changed
– [Luca Guidi] Drop support for Ruby 2.0, 2.1 and Rubinius. Official support for JRuby 9.0.5.0+.
- [Luca Guidi] Validations must be wrapped in `.validations` block.
- [Luca Guidi] Removed `.attribute` DSL. A validator doesn't create accessors (getters/setters) for validated keys.
- [Luca Guidi] Removed `Hanami::Validations#valid?` in favor of `#validate`.
- [Luca Guidi] Error messages are accessible via result object. Eg. `result.errors` or `result.errors(full: true)`
- [Luca Guidi] Coerced and sanitized data is accessible via result object. Eg. `result.output`

## v0.5.0 - 2016-01-22
### Changed
- [Luca Guidi] Renamed the project

## v0.4.0 - 2016-01-12
## Changed
- [Hélio Costa e Silva & Luca Guidi] Ignore blank values for format and size validation

### Fixed
- [Pascal Betz] Ensure acceptance validation to reject blank strings

## v0.3.3 - 2015-09-30
### Added
- [Luca Guidi] Official support for JRuby 9k+

## v0.3.2 - 2015-05-22
### Added
- [deepj] Introduced `Lotus::Validations#invalid?`

## v0.3.1 - 2015-05-15
### Fixed
- [Luca Guidi] Fixed Hash serialization for nested validations. It always return nested `::Hash` structure.
- [Alfonso Uceda Pompa & Dmitry Tymchuk] Fixed Hash serialization when `Lotus::Entity` is included in the same class.

## v0.3.0 - 2015-03-23

## v0.2.4 - 2015-01-30
### Added
- [Steve Hodgkiss] Introduced `Lotus::Validations::Error#attribute_name`
- [Steve Hodgkiss] Nested validations

### Changed
- [Steve Hodgkiss] `Lotus::Validations::Error#name` returns the complete attribute name (Eg. `first_name` or `address.street`)

## v0.2.3 - 2015-01-12
### Added
- [Luca Guidi] Compatibility with Lotus::Entity

### Fixed
- [Luca Guidi] Ensure `.validates` usage to not raise `ArgumentError` when `:type` option is passed
- [Luca Guidi] Ensure to assign attributes when only `.validates` is used

## v0.2.2 - 2015-01-08
### Added
- [Steve Hodgkiss] Introduced `Validations.validates`. It defines validations, for already existing attributes.

## v0.2.1 - 2014-12-23
### Added
- [Luca Guidi] Introduced `Validations::Errors#to_h` and `to_a`
- [Luca Guidi] Introduced `Validations::Errors#any?`
- [Luca Guidi] Official support for Ruby 2.2

### Fixed
- [Satoshi Amemiya] Made `Validations#valid?` idempotent

## v0.2.0 - 2014-11-23
### Added
- [Luca Guidi] Skip attribute whitelisting when a validator does not define any attribute
- [Luca Guidi] Official support for Rubinius 2.3+
- [Luca Guidi] Implemented `#each` in order to allow bulk operations on attributes
- [Luca Guidi] Implemented `#to_h` to make validations usable by other libraries
- [Luca Guidi] Made `#initialize` to accept Hashes with strings as keys, but only for declared attributes
- [Luca Guidi] Lazy coercions, from now on `valid?` is not required to obtain a coerced value from a single attribute
- [Rik Tonnard] Made validators reusable by allowing infinite inclusion

## v0.1.0 - 2014-10-23
### Added
- [Luca Guidi] Made `#initialize` to accept any object that implements `#to_h`
- [Luca Guidi] Custom coercions for user defined classes
- [Luca Guidi] Raise an exception at the load time when a validation is not recognized
- [Luca Guidi] Allow validators inheritance
- [Luca Guidi] Confirmation validation
- [Luca Guidi] Exclusion validation
- [Luca Guidi] Size validation
- [Luca Guidi] Acceptance validation
- [Jeremy Stephens] Inclusion validation
- [Luca Guidi] Format validation
- [Luca Guidi] Presence validation
- [Luca Guidi] Coercions
- [Luca Guidi] Basic module inclusion
- [Luca Guidi] Official support for JRuby 1.7+ (with 2.0 mode)
- [Luca Guidi] Official support for MRI 2.0+

### Fixed
- [Jeremy Stephens] Ensure to not fail validations when coerce falsey values
- [Luca Guidi] Ensure `Lotus::Validations#valid?` to be idempotent
