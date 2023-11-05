# frozen_string_literal: true

RSpec.describe Wrong::Example34 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[payload]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::OutputError,
              "[Wrong::Example34] Wrong type in output attribute hash `payload`, " \
              "expected `Hash` for `user`, got `NilClass`"
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
                     internals: %i[],
                     outputs: %i[payload]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::OutputError,
              "[Wrong::Example34] Wrong type in output attribute hash `payload`, " \
              "expected `Hash` for `user`, got `NilClass`"
            )
          )
        end
      end
    end
  end
end