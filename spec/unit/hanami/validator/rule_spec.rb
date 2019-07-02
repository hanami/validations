# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe ".rule" do
    let(:subject) do
      Class.new(described_class) do
        schema do
          required(:email).filled(:string)
          required(:age).value(:integer)
        end

        rule(:email) do
          key.failure("has invalid format") unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
        end

        rule(:age) do
          key.failure("must be greater than 18") if value < 18
        end
      end.new
    end

    it "validates input" do
      result = subject.call(email: "user@hanami.test", age: 37)
      expect(result).to be_success
    end

    it "returns errors for invalid input" do
      result = subject.call(email: "user@hanami.test", age: 17)
      expect(result).to_not be_success
      expect(result.errors[:email]).to be(nil)
      expect(result.errors[:age]).to match_array(["must be greater than 18"])

      result = subject.call(email: "user", age: 37)
      expect(result).to_not be_success
      expect(result.errors[:email]).to match_array(["has invalid format"])
      expect(result.errors[:age]).to be(nil)
    end

    context "multiple keys" do
      let(:subject) do
        Class.new(described_class) do
          schema do
            required(:start_date).value(:date)
            required(:end_date).value(:date)
          end

          rule(:end_date, :start_date) do
            key.failure("must be after start date") unless values[:end_date] >= values[:start_date]
          end
        end.new
      end

      it "validates input" do
        result = subject.call(start_date: Date.today, end_date: Date.today + 1)

        expect(result).to be_success
      end

      it "skips rule if input isn't formally correct" do
        result = subject.call(start_date: :foo, end_date: Date.today + 1)

        expect(result).to_not be_success
        expect(result.errors[:start_date]).to match_array(["must be a date"])
        expect(result.errors[:end_date]).to be(nil)
      end

      it "applies rules only if input is formally correct" do
        result = subject.call(start_date: Date.today, end_date: Date.today - 1)

        expect(result).to_not be_success
        expect(result.errors[:start_date]).to be(nil)
        expect(result.errors[:end_date]).to match_array(["must be after start date"])
      end
    end

    context "base rule" do
      let(:subject) do
        Class.new(described_class) do
          schema do
            required(:start_date).value(:date)
            required(:end_date).value(:date)
          end

          rule do
            base.failure("must be after start date") unless values[:end_date] >= values[:start_date]
          end
        end.new
      end

      it "applies rules to base" do
        result = subject.call(start_date: Date.today, end_date: Date.today - 1)

        expect(result).to_not be_success
        expect(result.errors[:start_date]).to be(nil)
        expect(result.errors[:end_date]).to be(nil)
        expect(result.errors[nil]).to match_array(["must be after start date"])
      end
    end

    context "base values" do
      context "base value" do
        let(:subject) do
          Class.new(described_class) do
            schema do
              required(:start_date).value(:date)
            end

            rule(:start_date) do
              key.failure("must be today") unless value == Date.today
            end
          end.new
        end

        it "yields value" do
          result = subject.call(start_date: Date.today + 1)

          expect(result).to_not be_success
          expect(result.errors[:start_date]).to match_array(["must be today"])
        end
      end

      context "dependent value" do
        let(:subject) do
          Class.new(described_class) do
            schema do
              required(:dates).hash do
                required(:start).value(:date)
              end
            end

            rule(dates: :start) do
              key.failure("must be today") unless value == Date.today
            end
          end.new
        end

        it "yields value" do
          result = subject.call(dates: { start: Date.today + 1 })

          expect(result).to_not be_success
          expect(result.errors[:dates][:start]).to match_array(["must be today"])
        end
      end

      context "dependent values" do
        let(:subject) do
          Class.new(described_class) do
            schema do
              required(:dates).hash do
                required(:start).value(:date)
                required(:ending).value(:date)
              end
            end

            rule(dates: %i[start ending]) do
              key.failure("must be after start date") unless value[1] >= value[0]
            end
          end.new
        end

        it "yields values" do
          result = subject.call(dates: { start: Date.today, ending: Date.today - 1 })

          expect(result).to_not be_success
          expect(result.errors[:dates][%i[start ending]]).to match_array(["must be after start date"])
        end
      end
    end

    context "key presence" do
      let(:subject) do
        Class.new(described_class) do
          schema do
            required(:email).value(:string)
            optional(:login).value(:string)
            optional(:password).value(:string)
          end

          rule(:password) do
            key.failure("password is required") if key? && values[:login] && value.length < 12
          end
        end.new
      end

      it "checks value presence" do
        result = subject.call(email: "user@hanami.test", login: "user", password: "")

        expect(result).to_not be_success
        expect(result.errors[:password]).to match_array(["password is required"])
      end
    end
  end
end
