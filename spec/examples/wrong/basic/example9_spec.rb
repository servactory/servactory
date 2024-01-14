# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example9 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_number: invoice_number
      }
    end

    let(:invoice_number) { "ABC-123" }

    include_examples "check class info",
                     inputs: %i[invoice_number],
                     internals: %i[],
                     outputs: %i[prepared_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::Failure,
              "[Wrong::Basic::Example9] Undefined local variable or method `assign_invoice_number`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_number`" do
        it_behaves_like "input required check", name: :invoice_number
        it_behaves_like "input type check", name: :invoice_number, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        invoice_number: invoice_number
      }
    end

    let(:invoice_number) { "ABC-123" }

    include_examples "check class info",
                     inputs: %i[invoice_number],
                     internals: %i[],
                     outputs: %i[prepared_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        include_examples "failure result class"

        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Errors::Failure)
          expect(result.error).to an_object_having_attributes(
            message: "[Wrong::Basic::Example9] Undefined local variable or method `assign_invoice_number`"
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_number`" do
        it_behaves_like "input required check", name: :invoice_number
        it_behaves_like "input type check", name: :invoice_number, expected_type: String
      end
    end
  end
end
