# frozen_string_literal: true

RSpec.describe Usual::Example64 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user: user
      }
    end

    let(:user) { Usual::Example64::User.new(active: true) }

    include_examples "check class info",
                     inputs: %i[user],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the user is not active" do
          let(:user) { Usual::Example64::User.new(active: false) }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::Failure,
                "User is not active"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `user`" do
        it_behaves_like "input required check", name: :user
        it_behaves_like "input type check", name: :user, expected_type: Usual::Example64::User
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user: user
      }
    end

    let(:user) { Usual::Example64::User.new(active: true) }

    include_examples "check class info",
                     inputs: %i[user],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the user is not active" do
          let(:user) { Usual::Example64::User.new(active: false) }

          include_examples "failure result class"

          it "returns the expected value in `errors`", :aggregate_failures do
            result = perform

            expect(result.error).to be_a(ApplicationService::Errors::Failure)
            expect(result.error).to an_object_having_attributes(
              message: "User is not active"
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `user`" do
        it_behaves_like "input required check", name: :user
        it_behaves_like "input type check", name: :user, expected_type: Usual::Example64::User
      end
    end
  end
end