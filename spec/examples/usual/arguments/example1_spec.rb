# frozen_string_literal: true

RSpec.describe Usual::Arguments::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        "invoice_number" => invoice_number
      }
    end

    let(:invoice_number) { "AA-7650AE" }

    it_behaves_like "check class info",
                    inputs: %i[invoice_number],
                    internals: %i[invoice_number],
                    outputs: %i[invoice_number]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      context "when `invoice_number` is `String`" do
        it do
          expect(perform).to(
            be_success_service
              .with_output(:invoice_number, "AA-7650AE")
          )
        end
      end

      context "when `invoice_number` is `Integer`" do
        let(:invoice_number) { 123 }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:invoice_number, 123)
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:invoice_number)
              .valid_with(attributes)
              .types(String, Integer)
              .required
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        "invoice_number" => invoice_number
      }
    end

    let(:invoice_number) { "AA-7650AE" }

    it_behaves_like "check class info",
                    inputs: %i[invoice_number],
                    internals: %i[invoice_number],
                    outputs: %i[invoice_number]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      context "when `invoice_number` is `String`" do
        it do
          expect(perform).to(
            be_success_service
              .with_output(:invoice_number, "AA-7650AE")
          )
        end
      end

      context "when `invoice_number` is `Integer`" do
        let(:invoice_number) { 123 }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:invoice_number, 123)
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:invoice_number)
              .valid_with(attributes)
              .types(String, Integer)
              .required
          )
        end
      end
    end
  end
end
