# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::MultipleOf::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[number],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Wrong::DynamicOptions::MultipleOf::Example4] " \
              "Internal attribute `number` has the value `10`, which is not a multiple of `0`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[number],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Wrong::DynamicOptions::MultipleOf::Example4] " \
              "Internal attribute `number` has the value `10`, which is not a multiple of `0`"
            )
          )
        end
      end
    end
  end
end
