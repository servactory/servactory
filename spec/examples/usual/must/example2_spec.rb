# frozen_string_literal: true

RSpec.describe Usual::Must::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[invoice_numbers],
                     outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:first_invoice_number?).with(true) }
        it { expect(perform).to have_output(:first_invoice_number).with("7650AE") }
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[invoice_numbers],
                     outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:first_invoice_number?).with(true) }
        it { expect(perform).to have_output(:first_invoice_number).with("7650AE") }
      end
    end
  end
end
