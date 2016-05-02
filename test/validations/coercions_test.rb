require 'test_helper'
require 'hanami/validations/coercions'

describe Hanami::Validations::Coercions do
  let(:t_nil)    { nil }
  let(:blank)    { '' }
  let(:string)   { 'foo' }
  let(:array)    { [] }
  let(:t_hash)   { {} }
  let(:t_true)   { true }
  let(:t_false)  { false }
  let(:int)      { 23 }
  let(:float)    { 1.0 }
  let(:decimal)  { BigDecimal.new(1) }
  let(:date)     { Date.today }
  let(:datetime) { DateTime.new }
  let(:t_time)   { Time.now }

  describe 'Array' do
    let(:type) { Array }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns array for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.must_be :success?
      result.value.must_equal []
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.wont_be :success?
      result.value.must_equal nil
    end
  end

  describe 'BigDecimal' do
    let(:type) { BigDecimal }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns bigdecimal for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.must_be :success?
      result.value.must_equal BigDecimal.new(int)
    end

    it 'returns bigdecimal for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.must_be :success?
      result.value.must_equal BigDecimal.new(float, 9)
    end

    it 'returns bigdecimal for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.must_be :success?
      result.value.must_equal decimal
    end

    it 'returns nil for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.wont_be :success?
      result.value.must_equal nil
    end
  end

  describe 'Boolean' do
    let(:type) { Boolean }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns false for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.must_be :success?
      result.value.must_equal false
    end

    it 'returns false for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.must_be :success?
      result.value.must_equal false
    end

    it 'returns false for "0"' do
      result = Hanami::Validations::Coercions.coerce(type, '0')

      result.must_be :success?
      result.value.must_equal false
    end

    it 'returns true for "1"' do
      result = Hanami::Validations::Coercions.coerce(type, '1')

      result.must_be :success?
      result.value.must_equal true
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns true for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.must_be :success?
      result.value.must_equal true
    end

    it 'returns false for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.must_be :success?
      result.value.must_equal false
    end

    it 'returns nil for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns false for 0' do
      result = Hanami::Validations::Coercions.coerce(type, 0)

      result.must_be :success?
      result.value.must_equal false
    end

    it 'returns true for 1' do
      result = Hanami::Validations::Coercions.coerce(type, 1)

      result.must_be :success?
      result.value.must_equal true
    end

    it 'returns nil for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.wont_be :success?
      result.value.must_equal nil
    end
  end

  describe 'Date' do
    let(:type) { Date }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns date for string that represent a date' do
      result = Hanami::Validations::Coercions.coerce(type, date.to_s)

      result.must_be :success?
      result.value.must_equal Date.parse(date.to_s)
    end

    it 'returns date for string that represent a date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime.to_s)

      result.must_be :success?
      result.value.must_equal Date.parse(datetime.to_s)
    end

    it 'returns date for string that represent a time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time.to_s)

      result.must_be :success?
      result.value.must_equal Date.parse(t_time.to_s)
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns date for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.must_be :success?
      result.value.must_equal date
    end

    it 'returns date for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.must_be :success?
      result.value.must_equal datetime.to_date
    end

    it 'returns date for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.must_be :success?
      result.value.must_equal t_time.to_date
    end
  end

  describe 'DateTime' do
    let(:type) { DateTime }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns date time for string that represent a date' do
      result = Hanami::Validations::Coercions.coerce(type, date.to_s)

      result.must_be :success?
      result.value.must_equal DateTime.parse(date.to_s)
    end

    it 'returns date time for string that represent a date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime.to_s)

      result.must_be :success?
      result.value.must_equal DateTime.parse(datetime.to_s)
    end

    it 'returns date time for string that represent a time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time.to_s)

      result.must_be :success?
      result.value.must_equal DateTime.parse(t_time.to_s)
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns date time for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.must_be :success?
      result.value.must_equal date.to_datetime
    end

    it 'returns date time for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.must_be :success?
      result.value.must_equal datetime
    end

    it 'returns date time for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.must_be :success?
      result.value.must_equal t_time.to_datetime
    end
  end

  describe 'Float' do
    let(:type) { Float }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns float for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.must_be :success?
      result.value.must_equal int.to_f
    end

    it 'returns float for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.must_be :success?
      result.value.must_equal float
    end

    it 'returns float for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.must_be :success?
      result.value.must_equal decimal.to_f
    end

    it 'returns nil for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.wont_be :success?
      result.value.must_equal nil
    end
  end

  describe 'Integer' do
    let(:type) { Integer }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns int for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.must_be :success?
      result.value.must_equal int
    end

    it 'returns int for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.must_be :success?
      result.value.must_equal float.to_i
    end

    it 'returns int for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.must_be :success?
      result.value.must_equal decimal.to_i
    end

    it 'returns nil for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.wont_be :success?
      result.value.must_equal nil
    end
  end
  describe 'Hash' do
    let(:type) { Hash }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns hash for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.must_be :success?
      result.value.must_equal t_hash
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.wont_be :success?
      result.value.must_equal nil
    end
  end

  describe 'String' do
    let(:type) { String }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns string for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.must_be :success?
      result.value.must_equal blank
    end

    it 'returns string for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.must_be :success?
      result.value.must_equal string
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns string for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.must_be :success?
      result.value.must_equal int.to_s
    end

    it 'returns string for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.must_be :success?
      result.value.must_equal float.to_s
    end

    it 'returns string for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.must_be :success?
      result.value.must_equal decimal.to_s
    end

    it 'returns string for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.must_be :success?
      result.value.must_equal date.to_s
    end

    it 'returns string for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.must_be :success?
      result.value.must_equal datetime.to_s
    end

    it 'returns string for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.must_be :success?
      result.value.must_equal t_time.to_s
    end
  end

  describe 'Time' do
    let(:type) { Time }

    it 'returns nil for nil' do
      result = Hanami::Validations::Coercions.coerce(type, t_nil)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for blank string' do
      result = Hanami::Validations::Coercions.coerce(type, blank)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for string' do
      result = Hanami::Validations::Coercions.coerce(type, string)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns time for string that represent a date' do
      result = Hanami::Validations::Coercions.coerce(type, date.to_s)

      result.must_be :success?
      result.value.must_equal Time.parse(date.to_s)
    end

    it 'returns time for string that represent a date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime.to_s)

      result.must_be :success?
      result.value.must_equal Time.parse(datetime.to_s)
    end

    it 'returns time for string that represent a time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time.to_s)

      result.must_be :success?
      result.value.must_equal Time.parse(t_time.to_s)
    end

    it 'returns nil for array' do
      result = Hanami::Validations::Coercions.coerce(type, array)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for hash' do
      result = Hanami::Validations::Coercions.coerce(type, t_hash)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for true' do
      result = Hanami::Validations::Coercions.coerce(type, t_true)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for false' do
      result = Hanami::Validations::Coercions.coerce(type, t_false)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for int' do
      result = Hanami::Validations::Coercions.coerce(type, int)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for float' do
      result = Hanami::Validations::Coercions.coerce(type, float)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns nil for big decimal' do
      result = Hanami::Validations::Coercions.coerce(type, decimal)

      result.wont_be :success?
      result.value.must_equal nil
    end

    it 'returns time for date' do
      result = Hanami::Validations::Coercions.coerce(type, date)

      result.must_be :success?
      result.value.must_equal date.to_time
    end

    it 'returns time for date time' do
      result = Hanami::Validations::Coercions.coerce(type, datetime)

      result.must_be :success?
      result.value.must_equal datetime.to_time
    end

    it 'returns time for time' do
      result = Hanami::Validations::Coercions.coerce(type, t_time)

      result.must_be :success?
      result.value.must_equal t_time
    end
  end

  describe 'custom coercions' do
    it 'coerces custom class' do
      result = Hanami::Validations::Coercions.coerce(FullName, ['Luca', 'Guidi'])

      result.must_be :success?
      result.value.must_be_kind_of(FullName)
      result.value.to_s.must_equal 'Luca Guidi'
    end

    it 'fails when an exception is raised' do
      result = Hanami::Validations::Coercions.coerce(Url, '')

      result.wont_be :success?
      result.value.must_equal nil
    end
  end
end
