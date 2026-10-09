# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::MultipleOf::Example8, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::DynamicOptions::MultipleOf::Example8] " \
            "Output attribute `number` has the value `100000000000000000001`, which is not a multiple of `2`"
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
                    outputs: %i[number]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::DynamicOptions::MultipleOf::Example8] " \
            "Output attribute `number` has the value `100000000000000000001`, which is not a multiple of `2`"
          )
        )
      end
    end
  end
end
