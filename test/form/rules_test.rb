require 'test_helper'
require 'uri'

describe Hanami::Validations::Form do
  describe 'rules' do
    before do
      @validator = Class.new do
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
    end

    let(:input) do
      Hash[
        'type'        => '1',
        'title'       => 'Developer',
        'description' => 'You know, to write code.',
        'company'     => 'Acme Inc.'
      ]
    end

    it 'is valid when location is filled and remote is missing' do
      data   = input.merge('location' => 'Rome')
      result = @validator.new(data).validate

      result.must_be :success?
      result.messages.must_be_empty
    end

    it 'is valid when location is filled and remote is false' do
      data   = input.merge('location' => 'Rome', 'remote' => '0')
      result = @validator.new(data).validate

      result.must_be :success?
      result.messages.must_be_empty
    end

    it 'is valid when location is missing and remote is true' do
      data   = input.merge('remote' => '1')
      result = @validator.new(data).validate

      result.must_be :success?
      result.messages.must_be_empty
    end

    it 'is invalid when both location and remote are missing' do
      data   = input
      result = @validator.new(data).validate

      result.wont_be :success?
      result.messages.wont_be_empty
    end

    it 'is invalid when location is missing and remote is false' do
      data   = input.merge('remote' => '0')
      result = @validator.new(data).validate

      result.wont_be :success?
      result.messages.fetch(:location).must_equal ['must be filled']
    end

    it 'is invalid when location is filled and remote is true' do
      data   = input.merge('location' => 'Rome', 'remote' => '1')
      result = @validator.new(data).validate

      result.wont_be :success?
      result.messages.fetch(:location).must_equal ['cannot be defined']
    end
  end
end
