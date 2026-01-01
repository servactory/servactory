# frozen_string_literal: true

RSpec.describe Usual::Must::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[invoice_numbers first_invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:first_invoice_number?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:first_invoice_number, "7650AE")
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[invoice_numbers first_invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:first_invoice_number?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:first_invoice_number, "7650AE")
          )
        end
      end
    end
  end
end
