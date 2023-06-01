# frozen_string_literal: true

RSpec.describe Wrong::Example13 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              NoMethodError,
              /undefined method `call'/
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
              NoMethodError,
              /undefined method `call'/
            )
          )
        end
      end
    end
  end
end
