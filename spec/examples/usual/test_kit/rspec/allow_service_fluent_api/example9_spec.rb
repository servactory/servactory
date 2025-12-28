# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example9, type: :service do
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
                    outputs: %i[order_summary]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with validate_outputs! and valid outputs" do
          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .as_success
              .inputs(order_id: "ORD-12345")
              .outputs(order_number: 1001, customer_name: "John Doe", total_amount: 99.99)
              .validate_outputs!
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:order_summary).contains("Order #1001: John Doe - $99.99") }
        end

        describe "with skip_output_validation after validate_outputs!" do
          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .as_success
              .inputs(order_id: "ORD-12345")
              .validate_outputs!
              .skip_output_validation
              .outputs(order_number: 2002, customer_name: "Jane Smith", total_amount: 150.00)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:order_summary).contains("Order #2002: Jane Smith - $150.0") }
        end
      end

      describe "but validate_outputs! catches invalid output names" do
        it "raises error for unknown output" do
          expect do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .as_success
              .validate_outputs!
              .outputs(unknown_output: "value")
          end.to raise_error(
            Servactory::TestKit::Rspec::Helpers::OutputValidator::ValidationError,
            /unknown_output/
          )
        end
      end

      describe "but validate_outputs! catches type mismatches" do
        it "raises error for wrong type" do
          expect do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .as_success
              .validate_outputs!
              .outputs(order_number: "not_an_integer")
          end.to raise_error(
            Servactory::TestKit::Rspec::Helpers::OutputValidator::ValidationError,
            /order_number.*Integer.*String/m
          )
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

    let(:order_id) { "ORD-67890" }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with validate_outputs! on non-bang allow_service" do
          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .as_success
              .validate_outputs!
              .outputs(order_number: 3003, customer_name: "Test User", total_amount: 200.50)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:order_summary).contains("Order #3003: Test User - $200.5") }
        end

        describe "without validate_outputs! allows any outputs" do
          before do
            # This would fail with validate_outputs! but passes without it
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .as_success
              .outputs(order_number: 4004, customer_name: "Unknown", total_amount: 0.0, extra_field: "ignored")
          end

          it_behaves_like "success result class"
        end
      end
    end
  end
end
