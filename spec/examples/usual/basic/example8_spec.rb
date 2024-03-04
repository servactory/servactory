# frozen_string_literal: true

RSpec.describe Usual::Basic::Example8 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        email: email,
        password: password
      }
    end

    let(:email) { "correct@email.com" }
    let(:password) { "correct_password" }

    include_examples "check class info",
                     inputs: %i[email password],
                     internals: %i[],
                     outputs: %i[user]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.user).to be_a(Usual::Basic::Example8::User)
          expect(result.user.email).to eq("correct@email.com")
          expect(result.user.password).to be_present
        end
      end

      describe "but the data required for work is invalid" do
        describe "because wrong email" do
          let(:email) { "wrong@email.com" }

          it "returns expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Errors::Failure)
                expect(exception.type).to eq(:base)
                expect(exception.message).to eq("Authentication failed")
                expect(exception.meta).to be_nil
              end
            )
          end
        end

        describe "because wrong password" do
          let(:password) { "wrong_password" }

          it "returns expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Errors::Failure)
                expect(exception.type).to eq(:base)
                expect(exception.message).to eq("Authentication failed")
                expect(exception.meta).to be_nil
              end
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `email`" do
        it_behaves_like "input required check", name: :email
        it_behaves_like "input type check", name: :email, expected_type: String
      end

      context "when `password`" do
        it_behaves_like "input required check", name: :password
        it_behaves_like "input type check", name: :password, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        email: email,
        password: password
      }
    end

    let(:email) { "correct@email.com" }
    let(:password) { "correct_password" }

    include_examples "check class info",
                     inputs: %i[email password],
                     internals: %i[],
                     outputs: %i[user]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.user).to be_a(Usual::Basic::Example8::User)
          expect(result.user.email).to eq("correct@email.com")
          expect(result.user.password).to be_present
        end
      end

      describe "but the data required for work is invalid" do
        describe "because wrong email" do
          let(:email) { "wrong@email.com" }

          include_examples "failure result class"

          it "returns the expected value in `errors`", :aggregate_failures do
            result = perform

            expect(result.error).to be_a(ApplicationService::Errors::Failure)
            expect(result.error).to an_object_having_attributes(
              type: :base,
              message: "Authentication failed",
              meta: nil
            )
          end
        end

        describe "because wrong password" do
          let(:password) { "wrong_password" }

          include_examples "failure result class"

          it "returns the expected value in `errors`", :aggregate_failures do
            result = perform

            expect(result.error).to be_a(ApplicationService::Errors::Failure)
            expect(result.error).to an_object_having_attributes(
              type: :base,
              message: "Authentication failed",
              meta: nil
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `email`" do
        it_behaves_like "input required check", name: :email
        it_behaves_like "input type check", name: :email, expected_type: String
      end

      context "when `password`" do
        it_behaves_like "input required check", name: :password
        it_behaves_like "input type check", name: :password, expected_type: String
      end
    end
  end
end
