# frozen_string_literal: true

RSpec.describe Wrong::Example15 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::OutputError,
              "[Wrong::Example15] Wrong output attribute collection type `ids`, expected `Set`, got `Array`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::OutputError,
              "[Wrong::Example15] Wrong output attribute collection type `ids`, expected `Set`, got `Array`"
            )
          )
        end
      end
    end
  end
end
