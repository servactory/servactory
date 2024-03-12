# frozen_string_literal: true

RSpec.describe Wrong::Collection::Example4, skip: "DELETE ME" do
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
              "[Wrong::Collection::Example4] Wrong element type in output attribute " \
              "collection `ids`, expected `String`, got `Integer`"
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
              "[Wrong::Collection::Example4] Wrong element type in output attribute " \
              "collection `ids`, expected `String`, got `Integer`"
            )
          )
        end
      end
    end
  end
end
