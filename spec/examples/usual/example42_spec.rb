# frozen_string_literal: true

RSpec.describe Usual::Example42 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns the expected value in `first_id`" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::Failure,
              "rollback with bad number"
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
        include_examples "failure result class"

        it "returns the expected value in `first_id`" do
          result = perform

          expect(result.number).to eq(8)
        end
      end
    end
  end
end
