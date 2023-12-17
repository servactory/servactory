# frozen_string_literal: true

RSpec.describe Usual::Basic::Example16 do
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
                     internals: %i[invoice_number],
                     outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when `invoice_number` is `String`" do
          it "returns the expected value in `invoice_number`" do
            result = perform

            expect(result.invoice_number).to eq("AA-7650AE")
          end
        end

        context "when `invoice_number` is `Integer`" do
          let(:invoice_number) { 123 }

          it "returns the expected value in `invoice_number`" do
            result = perform

            expect(result.invoice_number).to eq(123)
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_number`" do
        it_behaves_like "input required check", name: :invoice_number
        it_behaves_like "input type check", name: :invoice_number, expected_type: [String, Integer]
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
                     internals: %i[invoice_number],
                     outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when `invoice_number` is `String`" do
          it "returns the expected value in `invoice_number`" do
            result = perform

            expect(result.invoice_number).to eq("AA-7650AE")
          end
        end

        context "when `invoice_number` is `Integer`" do
          let(:invoice_number) { 123 }

          it "returns the expected value in `invoice_number`" do
            result = perform

            expect(result.invoice_number).to eq(123)
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_number`" do
        it_behaves_like "input required check", name: :invoice_number
        it_behaves_like "input type check", name: :invoice_number, expected_type: [String, Integer]
      end
    end
  end
end