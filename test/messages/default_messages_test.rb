require 'test_helper'

describe 'default validation messages' do
  describe 'when including Hanami::Validations::Messages in the view' do
    let(:view) { DefaultMessagesTest.new }

    it 'shows a message for :presence validation' do
      error = Hanami::Validations::Error.new(:street, :presence, true, 'Evergreen')

      view.validation_message_for(error).must_equal "can not be left blank"
    end

    it 'shows a message for :acceptance validation' do
      error = Hanami::Validations::Error.new(:street, :acceptance, true, 'Evergreen')

      view.validation_message_for(error).must_equal "must be accepted"
    end

    it 'shows a message for :confirmation validation' do
      error = Hanami::Validations::Error.new(:street, :confirmation, true, 'Evergreen')

      view.validation_message_for(error).must_equal "doesn't match"
    end

    it 'shows a message for :inclusion validation' do
      error = Hanami::Validations::Error.new(:street, :inclusion, ['a', 'b'], 'Evergreen')

      view.validation_message_for(error).must_equal "isn't included"
    end

    it 'shows a message for :exclusion validation' do
      error = Hanami::Validations::Error.new(:street, :exclusion, ['a', 'b'], 'Evergreen')

      view.validation_message_for(error).must_equal "shouldn't belong to a, b"
    end

    it 'shows a message for :format validation' do
      error = Hanami::Validations::Error.new(:street, :format, /abc/, 'Evergreen')

      view.validation_message_for(error).must_equal "doesn't match expected format"
    end

    it 'shows a message for :size validation' do
      error = Hanami::Validations::Error.new(:street, :size, 1..10, 'Evergreen')

      view.validation_message_for(error).must_equal "doesn't match expected size"
    end
  end

  describe 'when including sending #to_s to an Hanami::Validations::Error' do
    it 'shows a message for :presence validation' do
      error = Hanami::Validations::Error.new(:street, :presence, true, 'Evergreen')

      error.to_s.must_equal "can not be left blank"
    end

    it 'shows a message for :acceptance validation' do
      error = Hanami::Validations::Error.new(:street, :acceptance, true, 'Evergreen')

      error.to_s.must_equal "must be accepted"
    end

    it 'shows a message for :confirmation validation' do
      error = Hanami::Validations::Error.new(:street, :confirmation, true, 'Evergreen')

      error.to_s.must_equal "doesn't match"
    end

    it 'shows a message for :inclusion validation' do
      error = Hanami::Validations::Error.new(:street, :inclusion, ['a', 'b'], 'Evergreen')

      error.to_s.must_equal "isn't included"
    end

    it 'shows a message for :exclusion validation' do
      error = Hanami::Validations::Error.new(:street, :exclusion, ['a', 'b'], 'Evergreen')

      error.to_s.must_equal "shouldn't belong to a, b"
    end

    it 'shows a message for :format validation' do
      error = Hanami::Validations::Error.new(:street, :format, /abc/, 'Evergreen')

      error.to_s.must_equal "doesn't match expected format"
    end

    it 'shows a message for :size validation' do
      error = Hanami::Validations::Error.new(:street, :size, 1..10, 'Evergreen')

      error.to_s.must_equal "doesn't match expected size"
    end
  end
end