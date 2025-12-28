# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[greeting]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        describe "with exception object" do
          before do
            allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example2Child) do
              ApplicationService::Exceptions::Failure.new(
                type: :user_not_found,
                message: "User with ID 42 not found"
              )
            end
          end

          it "raises expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Failure)
                expect(exception.type).to eq(:user_not_found)
                expect(exception.message).to eq("User with ID 42 not found")
              end
            )
          end
        end

        describe "with exception hash" do
          before do
            allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example2Child) do
              {
                exception: ApplicationService::Exceptions::Failure.new(
                  type: :access_denied,
                  message: "Access denied"
                )
              }
            end
          end

          it "raises expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Failure)
                expect(exception.type).to eq(:access_denied)
                expect(exception.message).to eq("Access denied")
              end
            )
          end
        end

        describe "with with: parameter for argument matching" do
          before do
            allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example2Child,
                                      with: { user_id: 42 }) do
              ApplicationService::Exceptions::Failure.new(
                type: :specific_user_error,
                message: "Specific user 42 error"
              )
            end
          end

          it "raises expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception.type).to eq(:specific_user_error)
                expect(exception.message).to eq("Specific user 42 error")
              end
            )
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 99 }

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        describe "with exception object" do
          before do
            allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example2Child) do
              ApplicationService::Exceptions::Failure.new(
                type: :not_found,
                message: "User 99 not found"
              )
            end
          end

          it "returns failure result", :aggregate_failures do
            result = perform

            expect(result).to be_failure_service.type(:not_found)
            expect(result.error.message).to eq("User 99 not found")
          end
        end
      end
    end
  end
end
