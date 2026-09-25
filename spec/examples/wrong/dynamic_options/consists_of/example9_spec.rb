# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example9, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[ids]

    describe "but the output attribute type is not a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::DynamicOptions::ConsistsOf::Example9] Wrong output attribute collection type `ids`, " \
            "expected `Array, Set`, got `String`"
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

    describe "but the output attribute type is not a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::DynamicOptions::ConsistsOf::Example9] Wrong output attribute collection type `ids`, " \
            "expected `Array, Set`, got `String`"
          )
        )
      end
    end
  end
end
