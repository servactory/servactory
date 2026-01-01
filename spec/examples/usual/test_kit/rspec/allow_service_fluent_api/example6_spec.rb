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
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example6Child)
              .succeeds(status: :processing, attempt_number: 1)
              .then_succeeds(status: :processing, attempt_number: 2)
              .then_fails(type: :service_unavailable, message: "Service temporarily unavailable")
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:final_status, :error)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:total_attempts, 3)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:error_message, "Service temporarily unavailable")
            )
          end
        end

        describe "when child fails on first attempt" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example6Child)
              .fails(type: :connection_error, message: "Connection refused")
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:final_status, :error)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:total_attempts, 1)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:error_message, "Connection refused")
            )
          end
        end

        describe "when child succeeds on second attempt" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example6Child)
              .succeeds(status: :processing, attempt_number: 1)
              .then_succeeds(status: :completed, attempt_number: 2)
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:final_status, :completed)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:total_attempts, 2)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:error_message, nil)
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
        max_attempts:
      }
    end

    let(:max_attempts) { 2 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "when child fails after one success (sequential failure)" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example6Child)
              .succeeds(status: :processing, attempt_number: 1)
              .then_fails(type: :timeout, message: "Request timed out")
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:final_status, :error)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:error_message, "Request timed out")
            )
          end
        end
      end
    end
  end
end
