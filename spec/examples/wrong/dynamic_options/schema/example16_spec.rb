# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example16, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[payload]

    describe "but the output attribute type is not Hash-compatible" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::DynamicOptions::Schema::Example16] Wrong type of output attribute `payload`, " \
            "expected `Hash`, got `String`"
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
                    outputs: %i[payload]

    describe "but the output attribute type is not Hash-compatible" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::DynamicOptions::Schema::Example16] Wrong type of output attribute `payload`, " \
            "expected `Hash`, got `String`"
          )
        )
      end
    end
  end
end
