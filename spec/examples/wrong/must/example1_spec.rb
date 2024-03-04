# frozen_string_literal: true

RSpec.describe Wrong::Must::Example1 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_numbers: invoice_numbers
      }
    end

    let(:invoice_numbers) do
      %w[
        7650AE
        B4EA1B
        A7BC86
        BD2D6B
      ]
    end

    include_examples "check class info",
                     inputs: %i[invoice_numbers],
                     internals: %i[],
                     outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InputError,
              "[Wrong::Must::Example1] Syntax error inside `be_6_characters` of `invoice_numbers` input: " \
              "undefined local variable or method `this_method_does_not_exist' for class Wrong::Must::Example1"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        invoice_numbers: invoice_numbers
      }
    end

    let(:invoice_numbers) do
      %w[
        7650AE
        B4EA1B
        A7BC86
        BD2D6B
      ]
    end

    include_examples "check class info",
                     inputs: %i[invoice_numbers],
                     internals: %i[],
                     outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InputError,
              "[Wrong::Must::Example1] Syntax error inside `be_6_characters` of `invoice_numbers` input: " \
              "undefined local variable or method `this_method_does_not_exist' for class Wrong::Must::Example1"
            )
          )
        end
      end
    end
  end
end
