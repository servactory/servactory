# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example10 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[value]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          result = perform

          expect { result.fake_value }.to(
            raise_error(
              NoMethodError,
              "undefined method `fake_value' for #<Servactory::Result @failure?=false, @success?=true>"
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
                     outputs: %i[value]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          result = perform

          expect { result.fake_value }.to(
            raise_error(
              NoMethodError,
              "undefined method `fake_value' for #<Servactory::Result @failure?=false, @success?=true>"
            )
          )
        end
      end
    end
  end
end
