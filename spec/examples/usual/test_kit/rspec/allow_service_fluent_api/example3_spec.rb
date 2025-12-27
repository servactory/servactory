# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example3, type: :service do
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
      describe "and the data required for work is also valid" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example3Child)
            .as_success
            .with_outputs(user_name: "John Doe", user_email: "john@example.com")
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:greeting).contains("Hello, John Doe!") }
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails with call!" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :user_not_found,
              message: "User with ID 42 not found"
            )
          end

          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example3Child)
              .as_failure
              .with_exception(error)
          end

          it "raises expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Failure)
                expect(exception.type).to eq(:user_not_found)
                expect(exception.message).to eq("User with ID 42 not found")
                expect(exception.meta).to be_nil
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

    let(:user_id) { 42 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example3Child)
            .as_success
            .with_outputs(user_name: "John Doe", user_email: "john@example.com")
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:greeting).contains("Hello, John Doe!") }
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails with call!" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :user_not_found,
              message: "User with ID 42 not found"
            )
          end

          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example3Child)
              .as_failure
              .with_exception(error)
          end

          it "returns failure result with error", :aggregate_failures do
            # When parent is called with .call (not .call!), exceptions
            # from child are caught and returned as failure result
            result = perform

            expect(result).to be_failure_service.type(:user_not_found)
            expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          end
        end
      end
    end
  end
end
