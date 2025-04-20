# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_number:
      }
    end

    let(:invoice_number) { "ABC-123" }

    it_behaves_like "check class info",
                    inputs: %i[invoice_number],
                    internals: %i[],
                    outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::Basic::Example5] Wrong type of output attribute `invoice_number`, " \
              "expected `Integer`, got `String`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:invoice_number).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        invoice_number:
      }
    end

    let(:invoice_number) { "ABC-123" }

    it_behaves_like "check class info",
                    inputs: %i[invoice_number],
                    internals: %i[],
                    outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::Basic::Example5] Wrong type of output attribute `invoice_number`, " \
              "expected `Integer`, got `String`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:invoice_number).valid_with(attributes).type(String).required }
    end
  end
end
