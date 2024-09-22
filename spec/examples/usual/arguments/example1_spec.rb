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

    include_examples "check class info",
                     inputs: %i[invoice_number],
                     internals: %i[invoice_number],
                     outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when `invoice_number` is `String`" do
          it { expect(perform).to have_output(:invoice_number).with("AA-7650AE") }
        end

        context "when `invoice_number` is `Integer`" do
          let(:invoice_number) { 123 }

          it { expect(perform).to have_output(:invoice_number).with(123) }
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:invoice_number).valid_with(attributes).types(String, Integer).required }
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

    include_examples "check class info",
                     inputs: %i[invoice_number],
                     internals: %i[invoice_number],
                     outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when `invoice_number` is `String`" do
          it { expect(perform).to have_output(:invoice_number).with("AA-7650AE") }
        end

        context "when `invoice_number` is `Integer`" do
          let(:invoice_number) { 123 }

          it { expect(perform).to have_output(:invoice_number).with(123) }
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:invoice_number).valid_with(attributes).types(String, Integer).required }
    end
  end
end
