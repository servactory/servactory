# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::MultipleOf::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::DynamicOptions::MultipleOf::Example5] " \
              "Output attribute `number` has an invalid value `nil` in option `multiple_of`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::DynamicOptions::MultipleOf::Example5] " \
              "Output attribute `number` has an invalid value `nil` in option `multiple_of`"
            )
          )
        end
      end
    end
  end
end
