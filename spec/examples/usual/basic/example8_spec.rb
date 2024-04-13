# frozen_string_literal: true

RSpec.describe Usual::Basic::Example8, type: :service do
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

        it { expect(perform).to have_output(:user).instance_of(Usual::Basic::Example8::User) }
        it { expect(perform).to have_output(:user).nested(:email).with("correct@email.com") }
        it { expect(perform).to have_output(:user).nested(:password).with("correct_password") }
      end

      describe "but the data required for work is invalid" do
        describe "because wrong email" do
          let(:email) { "wrong@email.com" }

          it "returns expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Failure)
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
                expect(exception).to be_a(ApplicationService::Exceptions::Failure)
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
      it { expect { perform }.to have_input(:email).type(String).required }
      it { expect { perform }.to have_input(:password).type(String).required }
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

        it { expect(perform).to have_output(:user).instance_of(Usual::Basic::Example8::User) }
        it { expect(perform).to have_output(:user).nested(:email).with("correct@email.com") }
        it { expect(perform).to have_output(:user).nested(:password).with("correct_password") }
      end

      describe "but the data required for work is invalid" do
        describe "because wrong email" do
          let(:email) { "wrong@email.com" }

          include_examples "failure result class"

          it "returns the expected value in `errors`", :aggregate_failures do
            result = perform

            expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
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

            expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
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
      it { expect { perform }.to have_input(:email).type(String).required }
      it { expect { perform }.to have_input(:password).type(String).required }
    end
  end
end
