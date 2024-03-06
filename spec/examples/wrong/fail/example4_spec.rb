# frozen_string_literal: true

RSpec.describe Wrong::Fail::Example4 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        before do
          allow(Wrong::Fail::Example4Child).to(
            receive(:call!).and_raise(
              ApplicationService::Exceptions::Failure.new(message: "Some overridden error")
            )
          )
        end

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Some overridden error")
              expect(exception.meta).to be_nil
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
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        before do
          allow(Wrong::Fail::Example4Child).to(
            receive(:call!).and_raise(
              ApplicationService::Exceptions::Failure.new(message: "Some overridden error")
            )
          )
        end

        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Some overridden error",
            meta: nil
          )
        end
      end
    end
  end
end
