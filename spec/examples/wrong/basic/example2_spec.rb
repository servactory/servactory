# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example2, type: :service do
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

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:invoice_number)
              .valid_with(false)
              .type(String)
              .required
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Basic::Example2] Undefined input attribute `number`"
          )
        )
      end
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

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:invoice_number)
              .valid_with(false)
              .type(String)
              .required
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Basic::Example2] Undefined input attribute `number`"
          )
        )
      end
    end
  end
end
