require 'test_helper'

describe Lotus::Validations do
  describe 'size' do
    it "is valid if it doesn't have attributes" do
      validator = SizeValidatorTest.new({})

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "is valid if the size matches" do
      size   = 11
      values = [
        'x' * size,
        ('x' * size).to_sym,
        Array.new(size),
        Hash[(0...size).map {|i| [i, 'x']}],
        Set.new((0...size)),
        Range.new(0, size - 1),
      ]

      values.each do |value|
        validator = SizeValidatorTest.new({ssn: value})

        validator.valid?.must_equal true
        validator.errors.must_be_empty
      end
    end

    it "is valid if the size is included in the given range" do
      size   = 23
      values = [
        'x' * size,
        ('x' * size).to_sym,
        Array.new(size),
        Hash[(0...size).map {|i| [i, 'x']}],
        Set.new((0...size)),
        Range.new(0, size)
      ]

      values.each do |value|
        validator = SizeValidatorTest.new({password: value})

        validator.valid?.must_equal true
        validator.errors.must_be_empty
      end
    end

    it "is valid if the size can be coercible into an integer and the value size matches" do
      validator = SizeValidatorTest.new({cf: 'XXXXXX00X00X000X'})

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "isn't valid if the size doesn't match" do
      size   = 100
      values = [
        'x' * size,
        ('x' * size).to_sym,
        23 ** size,
        23 ** (size * 10),
        Array.new(size),
        Hash[(0...size).map {|i| [i, 'x']}],
        Set.new((0...size)),
        Range.new(0, size),
        File.new(__FILE__),
        Pathname.new(__FILE__)
      ]

      values.each do |value|
        validator = SizeValidatorTest.new({ssn: value})

        validator.valid?.must_equal false
        errors = validator.errors.for(:ssn)
        errors.must_include Lotus::Validations::Error.new(:ssn, :size, 11, value)
      end
    end

    it "isn't valid if the size isn't included in the given range" do
      size   = 100
      values = [
        # low            high
        'x',             'x' * size,
        :x,              ('x' * size).to_sym,
        23,              23 ** size,
                         23 ** (size * 10),
        Array.new,       Array.new(size),
        Hash.new,        Hash[(0...size).map {|i| [i, 'x']}],
        Set.new,         Set.new((0...size)),
        Range.new(0, 0), Range.new(0, size),
                         File.new(__FILE__),
                         Pathname.new(__FILE__)
      ]

      values.each do |value|
        validator = SizeValidatorTest.new({password: value})

        validator.valid?.must_equal false
        errors = validator.errors.for(:password)
        errors.must_include Lotus::Validations::Error.new(:password, :size, 9..56, value)
      end
    end

    it "raises an error when the validator can't be coerced into an integer" do
      -> { SizeValidatorErrorTest.new(password: 'secret').valid? }.must_raise ArgumentError
    end
  end
end
