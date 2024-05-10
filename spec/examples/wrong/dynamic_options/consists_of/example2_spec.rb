# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[ids],
                     outputs: %i[ids]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::DynamicOptions::ConsistsOf::Example2] Wrong type of output attribute `ids`, " \
              "expected `Set`, got `Array`"
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
                     internals: %i[ids],
                     outputs: %i[ids]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::DynamicOptions::ConsistsOf::Example2] Wrong type of output attribute `ids`, " \
              "expected `Set`, got `Array`"
            )
          )
        end
      end
    end
  end
end
