# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example6, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        max_attempts:
      }
    end

    let(:max_attempts) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[max_attempts],
                    internals: %i[],
                    outputs: %i[final_status total_attempts error_message]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "when child succeeds after retries then fails" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :service_unavailable,
              message: "Service temporarily unavailable"
            )
          end

          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example6Child)
              .as_success
              .outputs(status: :processing, attempt_number: 1)
              .then_as_success
              .outputs(status: :processing, attempt_number: 2)
              .then_as_failure
              .with_exception(error)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:error) }
          it { expect(perform).to have_output(:total_attempts).contains(3) }
          it { expect(perform).to have_output(:error_message).contains("Service temporarily unavailable") }
        end

        describe "when child fails on first attempt" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :connection_error,
              message: "Connection refused"
            )
          end

          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example6Child)
              .as_failure
              .with_exception(error)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:error) }
          it { expect(perform).to have_output(:total_attempts).contains(1) }
          it { expect(perform).to have_output(:error_message).contains("Connection refused") }
        end

        describe "when child succeeds on second attempt" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example6Child)
              .as_success
              .outputs(status: :processing, attempt_number: 1)
              .then_as_success
              .outputs(status: :completed, attempt_number: 2)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:completed) }
          it { expect(perform).to have_output(:total_attempts).contains(2) }
          it { expect(perform).to have_output(:error_message).contains(nil) }
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        max_attempts:
      }
    end

    let(:max_attempts) { 2 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "when child fails after one success (sequential failure)" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :timeout,
              message: "Request timed out"
            )
          end

          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example6Child)
              .as_success
              .outputs(status: :processing, attempt_number: 1)
              .then_as_failure
              .with_exception(error)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:error) }
          it { expect(perform).to have_output(:error_message).contains("Request timed out") }
        end
      end
    end
  end
end
