# frozen_string_literal: true

RSpec.describe Wrong::Example16 do
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
              ApplicationService::Errors::OutputError,
              "[Wrong::Example16] Wrong element type in output attribute collection `ids`, expected `String`"
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
              ApplicationService::Errors::OutputError,
              "[Wrong::Example16] Wrong element type in output attribute collection `ids`, expected `String`"
            )
          )
        end
      end
    end
  end
end
