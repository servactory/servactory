# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 47 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[greeting]

    describe "but the data required for work is invalid" do
      describe "with exception object" do
        before do
          allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example2Child) do
            ApplicationService::Exceptions::Failure.new(
              type: :user_not_found,
              message: "User with ID 47 not found"
            )
          end
        end

        it "raises expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:user_not_found)
              expect(exception.message).to eq("User with ID 47 not found")
              expect(exception.meta).to be_nil
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
              expect(exception.meta).to be_nil
            end
          )
        end
      end

      describe "with with: parameter for argument matching" do
        before do
          allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example2Child,
                                    with: { user_id: 47 }) do
            ApplicationService::Exceptions::Failure.new(
              type: :specific_user_error,
              message: "Specific user 47 error"
            )
          end
        end

        it "raises expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:specific_user_error)
              expect(exception.message).to eq("Specific user 47 error")
              expect(exception.meta).to be_nil
            end
          )
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

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[greeting]

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

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :not_found,
            message: "User 99 not found",
            meta: nil
          )
        end
      end
    end
  end
end
