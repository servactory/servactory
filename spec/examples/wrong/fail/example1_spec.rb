# frozen_string_literal: true

RSpec.describe Wrong::Fail::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      it "returns expected error", :aggregate_failures do
        expect { perform }.to(
          raise_error do |exception|
            expect(exception).to be_a(ApplicationService::Exceptions::Failure)
            expect(exception.type).to eq(:base)
            expect(exception.message).to(
              eq(
                "[Wrong::Fail::Example1] The following methods cannot be overwritten: " \
                "`fail_input!`, `fail_internal!`, `fail_output!`, `fail!`, `fail_result!`"
              )
            )
            expect(exception.meta).to be_nil
          end
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      it "returns the expected value in `errors`", :aggregate_failures do
        result = perform

        expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
        expect(result.error).to an_object_having_attributes(
          type: :base,
          message: "[Wrong::Fail::Example1] The following methods cannot be overwritten: " \
                   "`fail_input!`, `fail_internal!`, `fail_output!`, `fail!`, `fail_result!`",
          meta: nil
        )
      end
    end
  end
end
