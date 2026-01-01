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
            .succeeds(order_status: :shipped, shipped_at: Time.now)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:tracking_status, :shipped)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:error_message, nil)
          )
        end
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails with explicit exception" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example4Child)
              .fails(type: :order_not_found, message: "Order ORD-12345 not found")
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:tracking_status, :error)
            )
          end

          it do
            expect(perform).to(
              be_success_service
                .with_output(:error_message, "Order ORD-12345 not found")
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
        order_id:
      }
    end

    let(:order_id) { "ORD-12345" }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example4Child)
            .succeeds(order_status: :shipped, shipped_at: Time.now)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:tracking_status, :shipped)
          )
        end
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails with explicit exception" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example4Child)
              .fails(type: :order_not_found, message: "Order ORD-12345 not found")
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
