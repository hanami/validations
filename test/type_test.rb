require 'test_helper'

describe Lotus::Validations do
  describe '.type' do
    before do
      @validator = TypeValidatorTest.new({
        unmapped:           'Hello',
        untyped:            '23',
        array_attr:         Set.new(['a', 'b']),
        boolean_true_attr:  '1',
        boolean_false_attr: '0',
        date_attr:          '2014-08-03',
        datetime_attr:      '2014-08-03 18:05:18',
        float_attr:         '3.14',
        hash_attr:          [[:a, 1]],
        integer_attr:       '23',
        pathname_attr:      'test/test_helper.rb',
        set_attr:           [1, 2],
        string_attr:        23,
        symbol_attr:        'symbol',
        time_attr:          '1407082408'
      })

      @validator.valid?
    end

    it "doesn't coerce un-typed attributes" do
      @validator.untyped.must_equal '23'
    end

    it 'coerces Array' do
      @validator.array_attr.must_be_kind_of(Array)
    end

    it 'coerces Boolean true' do
      @validator.boolean_true_attr.must_be_kind_of(TrueClass)
    end

    it 'coerces Boolean false' do
      @validator.boolean_false_attr.must_be_kind_of(FalseClass)
      @validator.errors.must_be_empty
    end

    it 'coerces Date' do
      @validator.date_attr.must_be_kind_of(Date)
    end

    it 'coerces DateTime' do
      @validator.datetime_attr.must_be_kind_of(DateTime)
    end

    it 'coerces Float' do
      @validator.float_attr.must_be_kind_of(Float)
    end

    it 'coerces Hash' do
      @validator.hash_attr.must_be_kind_of(Hash)
    end

    it 'coerces Integer' do
      @validator.integer_attr.must_be_kind_of(Integer)
    end

    it 'coerces Pathname' do
      @validator.pathname_attr.must_be_kind_of(Pathname)
    end

    it 'coerces String' do
      @validator.string_attr.must_be_kind_of(String)
    end

    it 'coerces Symbol' do
      @validator.symbol_attr.must_be_kind_of(Symbol)
    end

    it 'coerces Time' do
      @validator.time_attr.must_be_kind_of(Time)
    end
  end
end
