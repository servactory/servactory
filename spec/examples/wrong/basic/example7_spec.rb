# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example7, type: :service do
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
                ApplicationService::Exceptions::Input,
                "[Wrong::Basic::Example7] Unexpected attributes: `invoice_code`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:invoice_number).direct(attributes).type(String).required }
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
                ApplicationService::Exceptions::Input,
                "[Wrong::Basic::Example7] Unexpected attributes: `invoice_code`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:invoice_number).direct(attributes).type(String).required }
    end
  end
end
