# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example9 do
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
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(NameError)
              expect(exception.message).to(
                match(/undefined local variable or method `invoice_number' for (.*)Wrong::Basic::Example9(.*)/)
              )
            end
          )
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

    let(:invoice_number) { "ABC-123" }

    include_examples "check class info",
                     inputs: %i[invoice_number],
                     internals: %i[],
                     outputs: %i[prepared_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(NameError)
              expect(exception.message).to(
                match(/undefined local variable or method `invoice_number' for (.*)Wrong::Basic::Example9(.*)/)
              )
            end
          )
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
