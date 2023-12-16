# frozen_string_literal: true

RSpec.describe Wrong::Example26 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[payload],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InternalError,
              "[Wrong::Example26] Wrong type in internal attribute hash `payload`, " \
              "expected `String` for `last_name`, got `NilClass`"
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
                     internals: %i[payload],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InternalError,
              "[Wrong::Example26] Wrong type in internal attribute hash `payload`, " \
              "expected `String` for `last_name`, got `NilClass`"
            )
          )
        end
      end
    end
  end
end
