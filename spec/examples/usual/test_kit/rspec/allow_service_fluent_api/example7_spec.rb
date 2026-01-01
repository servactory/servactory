# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example7, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    let(:mock_timestamp) { Time.new(2024, 1, 15, 12, 0, 0) }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[health_check_time system_status]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with no_inputs matcher" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example7Child)
              .with(no_inputs)
              .succeeds(timestamp: mock_timestamp, status: :healthy)
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:health_check_time, mock_timestamp)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:system_status, :healthy)
            )
          end
        end

        describe "with service returning degraded status" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example7Child)
              .with(no_inputs)
              .succeeds(timestamp: mock_timestamp, status: :degraded)
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:system_status, :degraded)
            )
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    let(:mock_timestamp) { Time.new(2024, 1, 15, 14, 30, 0) }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with no_inputs matcher" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example7Child)
              .with(no_inputs)
              .succeeds(timestamp: mock_timestamp, status: :healthy)
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:health_check_time, mock_timestamp)
            )
          end
        end
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example7Child)
              .fails(type: :health_check_failed, message: "Service unreachable")
          end

          it "returns failure result with error", :aggregate_failures do
            result = perform

            expect(result).to be_failure_service.type(:health_check_failed)
            expect(result.error.message).to eq("Service unreachable")
          end
        end
      end
    end
  end
end
