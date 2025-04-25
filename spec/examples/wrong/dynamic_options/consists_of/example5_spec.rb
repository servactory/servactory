# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[ids],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Wrong::DynamicOptions::ConsistsOf::Example5] Wrong element type in internal attribute " \
              "collection `ids`, expected `String`, got `Integer`"
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
                    internals: %i[ids],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Wrong::DynamicOptions::ConsistsOf::Example5] Wrong element type in internal attribute " \
              "collection `ids`, expected `String`, got `Integer`"
            )
          )
        end
      end
    end
  end
end
