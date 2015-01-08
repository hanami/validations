# Lotus::Validations
Validations mixin for Ruby objects

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
