# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[ids]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::DynamicOptions::ConsistsOf::Example4] Required element in output " \
            "attribute collection `ids` is missing"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[ids]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::DynamicOptions::ConsistsOf::Example4] Required element in output " \
            "attribute collection `ids` is missing"
          )
        )
      end
    end
  end
end
