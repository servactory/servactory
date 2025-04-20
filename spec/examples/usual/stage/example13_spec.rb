# frozen_string_literal: true

RSpec.describe Usual::Stage::Example13, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Invalid number")
              expect(exception.meta).to match(
                original_exception: be_an_instance_of(
                  Usual::Stage::Example13Transaction::LikeAnActiveRecordException
                )
              )
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it_behaves_like "failure result class"

        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Invalid number",
            meta: {
              original_exception: be_an_instance_of(
                Usual::Stage::Example13Transaction::LikeAnActiveRecordException
              )
            }
          )
        end
      end
    end
  end
end
