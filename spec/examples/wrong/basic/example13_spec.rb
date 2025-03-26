# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example13, type: :service do
  let(:attributes) do
    {
      invoice_number:
    }
  end

  let(:invoice_number) { "ABC-123" }

  include_examples "check class info",
                   inputs: %i[invoice_number],
                   internals: %i[],
                   outputs: %i[]

  describe "validation" do
    describe "inputs" do
      it do
        expect { perform }.to(
          have_input(:invoice_number)
            .valid_with(attributes)
            .required
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Basic::Example13] Wrong type of output attribute `invoice_number`, " \
              "expected `Integer`, got `NilClass`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Basic::Example13] Wrong type of output attribute `invoice_number`, " \
              "expected `Integer`, got `NilClass`"
          )
        )
      end
    end
  end
end
