# frozen_string_literal: true

RSpec.describe Wrong::Example9 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_number:
      }
    end

    let(:invoice_number) { "ABC-123" }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.prepared_invoice_number).to eq("123")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because there is an unexpected key in the attributes" do
          let(:attributes) do
            {
              invoice_code: invoice_number
            }
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputArgumentError,
                "[Wrong::Example9] Unexpected attributes: `invoice_code`"
              )
            )
          end
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
