# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::MultipleOf::Example7, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[number],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::MultipleOf::Example7] " \
            "Internal attribute `number` has the value `0.35`, which is not a multiple of `-0.1`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[number],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::MultipleOf::Example7] " \
            "Internal attribute `number` has the value `0.35`, which is not a multiple of `-0.1`"
          )
        )
      end
    end
  end
end
