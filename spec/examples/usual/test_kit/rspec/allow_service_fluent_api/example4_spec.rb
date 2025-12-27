# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        order_id:
      }
    end

    let(:order_id) { "ORD-12345" }

    it_behaves_like "check class info",
                    inputs: %i[order_id],
                    internals: %i[],
                    outputs: %i[tracking_status error_message]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example4Child)
            .as_success
            .with_outputs(order_status: :shipped, shipped_at: Time.now)
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:tracking_status).contains(:shipped) }
        it { expect(perform).to have_output(:error_message).contains(nil) }
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails with explicit exception" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :order_not_found,
              message: "Order ORD-12345 not found"
            )
          end

          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example4Child)
              .as_failure
              .with_exception(error)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:tracking_status).contains(:error) }
          it { expect(perform).to have_output(:error_message).contains("Order ORD-12345 not found") }
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        order_id:
      }
    end

    let(:order_id) { "ORD-12345" }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example4Child)
            .as_success
            .with_outputs(order_status: :shipped, shipped_at: Time.now)
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:tracking_status).contains(:shipped) }
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails with explicit exception" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :order_not_found,
              message: "Order ORD-12345 not found"
            )
          end

          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example4Child)
              .as_failure
              .with_exception(error)
          end

          it "handles failure result", :aggregate_failures do
            expect(perform).to have_output(:tracking_status).contains(:error)
            expect(perform).to have_output(:error_message).contains("Order ORD-12345 not found")
          end
        end
      end
    end
  end
end
