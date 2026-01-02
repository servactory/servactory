# frozen_string_literal: true

RSpec.describe Usual::Must::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[invoice_numbers],
                    outputs: %i[first_invoice_number]
    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:first_invoice_number)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              first_invoice_number: "7650AE",
              first_invoice_number?: true
            )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[invoice_numbers],
                    outputs: %i[first_invoice_number]
    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:first_invoice_number)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              first_invoice_number: "7650AE",
              first_invoice_number?: true
            )
        )
      end
    end
  end
end
