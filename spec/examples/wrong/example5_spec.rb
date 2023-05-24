# frozen_string_literal: true

RSpec.describe Wrong::Example5 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_number: invoice_number
      }
    end

    let(:invoice_number) { "ABC-123" }

    context "when the input attributes are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::OutputError,
              "[Wrong::Example5] Wrong type of output attribute `invoice_number`, expected `Integer`, got `String`"
            )
          )
        end
      end
    end

    context "when the input attributes are invalid" do
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

    context "when the input attributes are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::OutputError,
              "[Wrong::Example5] Wrong type of output attribute `invoice_number`, expected `Integer`, got `String`"
            )
          )
        end
      end
    end

    context "when the input attributes are invalid" do
      context "when `invoice_number`" do
        it_behaves_like "input required check", name: :invoice_number
        it_behaves_like "input type check", name: :invoice_number, expected_type: String
      end
    end
  end
end
