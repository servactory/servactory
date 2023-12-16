# frozen_string_literal: true

RSpec.describe Usual::Fail::Example1 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_number: invoice_number
      }
    end

    let(:invoice_number) { "AA-7650AE" }

    include_examples "check class info",
                     inputs: %i[invoice_number],
                     internals: %i[],
                     outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `invoice_number`" do
          result = perform

          expect(result.invoice_number).to eq("AA-7650AE")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because invalid invoice number" do
          let(:invoice_number) { "BB-7650AE" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::Failure,
                "Invalid invoice number"
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

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        invoice_number: invoice_number
      }
    end

    let(:invoice_number) { "AA-7650AE" }

    include_examples "check class info",
                     inputs: %i[invoice_number],
                     internals: %i[],
                     outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `invoice_number`" do
          result = perform

          expect(result.invoice_number).to eq("AA-7650AE")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because invalid invoice number" do
          let(:invoice_number) { "BB-7650AE" }

          include_examples "failure result class"

          it "returns the expected value in `errors`", :aggregate_failures do
            result = perform

            expect(result.error).to be_a(ApplicationService::Errors::Failure)
            expect(result.error).to an_object_having_attributes(
              message: "Invalid invoice number"
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
