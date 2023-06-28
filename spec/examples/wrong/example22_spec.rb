# frozen_string_literal: true

RSpec.describe Wrong::Example22 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          result = perform

          expect { result.fake_value }.to(
            raise_error(
              NoMethodError,
              "undefined method `fake_value' for #<Servactory::Result @success?=true, @failure?=false>"
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
          result = perform

          expect { result.fake_value }.to(
            raise_error(
              NoMethodError,
              "undefined method `fake_value' for #<Servactory::Result @success?=true, @failure?=false>"
            )
          )
        end
      end
    end
  end
end
