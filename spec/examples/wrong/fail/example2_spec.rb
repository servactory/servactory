# frozen_string_literal: true

RSpec.describe Wrong::Fail::Example2 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Errors::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("There's some problem with `number`")
            end
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
                     outputs: %i[number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Errors::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "There's some problem with `number`"
          )
        end
      end
    end
  end
end