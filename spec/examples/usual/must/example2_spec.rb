# frozen_string_literal: true

RSpec.describe Usual::Must::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[invoice_numbers],
                    outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:first_invoice_number?).contains(true) }
        it { expect(perform).to have_output(:first_invoice_number).contains("7650AE") }
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[invoice_numbers],
                    outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:first_invoice_number?).contains(true) }
        it { expect(perform).to have_output(:first_invoice_number).contains("7650AE") }
      end
    end
  end
end
