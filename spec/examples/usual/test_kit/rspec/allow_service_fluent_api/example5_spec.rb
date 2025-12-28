# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        product_id:,
        quantity:,
        customer_id:
      }
    end

    let(:product_id) { "PROD-001" }
    let(:quantity) { 5 }
    let(:customer_id) { "CUST-123" }

    it_behaves_like "check class info",
                    inputs: %i[product_id quantity customer_id],
                    internals: %i[],
                    outputs: %i[order_total has_discount]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with exact input matching" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example5Child)
              .as_success
              .inputs(product_id: "PROD-001", quantity: 5, customer_id: "CUST-123")
              .outputs(line_total: 500, discount_applied: false)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:order_total).contains(500) }
          it { expect(perform).to have_output(:has_discount).contains(false) }
        end

        describe "with partial input matching using including()" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example5Child)
              .as_success
              .inputs(including(quantity: 5))
              .outputs(line_total: 500, discount_applied: true)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:order_total).contains(500) }
          it { expect(perform).to have_output(:has_discount).contains(true) }
        end

        describe "with partial input matching for multiple keys" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example5Child)
              .as_success
              .inputs(including(product_id: "PROD-001", quantity: 5))
              .outputs(line_total: 1000, discount_applied: true)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:order_total).contains(1000) }
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        product_id:,
        quantity:,
        customer_id:
      }
    end

    let(:product_id) { "PROD-001" }
    let(:quantity) { 5 }
    let(:customer_id) { "CUST-123" }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with any_inputs matcher" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example5Child)
              .as_success
              .inputs(any_inputs)
              .outputs(line_total: 500, discount_applied: false)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:order_total).contains(500) }
        end

        describe "with excluding() matcher" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example5Child)
              .as_success
              .inputs(excluding(secret_key: anything))
              .outputs(line_total: 750, discount_applied: true)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:order_total).contains(750) }
        end
      end
    end
  end
end
