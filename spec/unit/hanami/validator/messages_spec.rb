# frozen_string_literal: true

RSpec.describe Hanami::Validator do
  describe "messages" do
    %i[yaml i18n].each do |backend|
      context "#{backend.to_s.capitalize} backend" do
        let(:base) do
          Class.new(described_class) do
            config.messages.backend = backend
            config.messages.top_namespace = "bookshelf"
            config.messages.load_paths << SPEC_ROOT.join("support", "errors.yml")
          end
        end

        subject do
          Class.new(base) do
            schema do
              required(:username).filled(:string)
            end

            rule(:username) do
              key.failure(:taken) if values[:username] == "jodosha"
            end
          end.new
        end

        it "validates input" do
          result = subject.call(username: "foo")
          expect(result).to be_success
          expect(result.to_h).to eq(username: "foo")

          result = subject.call(username: "jodosha")
          expect(result).to_not be_success
          expect(result.to_h).to eq(username: "jodosha")
          expect(result.errors[:username]).to match_array(["oh noes, it's already taken"])
        end

        context "with interpolated message" do
          subject do
            Class.new(base) do
              schema do
                required(:refunded_code).filled(:string)
              end

              rule(:refunded_code) do
                key.failure(:network, code: "123") if values[:refunded_code] == "error"
              end
            end.new
          end

          it "validates input" do
            result = subject.call(refunded_code: "abc")
            expect(result).to be_success
            expect(result.to_h).to eq(refunded_code: "abc")

            result = subject.call(refunded_code: "error")
            expect(result).to_not be_success
            expect(result.to_h).to eq(refunded_code: "error")
            expect(result.errors[:refunded_code]).to match_array(["there is a network error (123)"])
          end
        end

        context "with rules error messages" do
          subject do
            Class.new(base) do
              schema do
                required(:email).filled(:string)
                required(:age).filled(:integer)
              end

              rule(:email) do
                key.failure(:invalid) unless values[:email] =~ /@/
              end

              rule(:age) do
                key.failure(:invalid) if values[:age] < 18
              end
            end.new
          end

          it "validates input" do
            result = subject.call(email: "user@hanami.test", age: 37)
            expect(result).to be_success
            expect(result.to_h).to eq(email: "user@hanami.test", age: 37)

            result = subject.call(email: "user", age: 17)
            expect(result).to_not be_success
            expect(result.to_h).to eq(email: "user", age: 17)
            expect(result.errors[:email]).to match_array(["not a valid email"])
            expect(result.errors[:age]).to match_array(["must be greater than 18"])
          end
        end
      end
    end
  end
end
