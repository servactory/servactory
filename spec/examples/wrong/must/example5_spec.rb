# frozen_string_literal: true

RSpec.describe Wrong::Must::Example5 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[invoice_numbers first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::OutputError,
              "[Wrong::Must::Example5] Syntax error inside `be_6_characters` of `invoice_numbers` output attribute"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[invoice_numbers first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::OutputError,
              "[Wrong::Must::Example5] Syntax error inside `be_6_characters` of `invoice_numbers` output attribute"
            )
          )
        end
      end
    end
  end
end