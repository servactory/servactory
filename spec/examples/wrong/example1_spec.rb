# frozen_string_literal: true

RSpec.describe Wrong::Example1 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_number: invoice_number
      }
    end

    let(:invoice_number) { "ABC-123" }

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InternalArgumentError,
              "[Wrong::Example1] Wrong type of internal argument `prepared_invoice_number`, " \
              "expected `Integer`, got `String`"
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

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InternalArgumentError,
              "[Wrong::Example1] Wrong type of internal argument `prepared_invoice_number`, " \
              "expected `Integer`, got `String`"
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
end
