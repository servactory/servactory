# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceAsSuccessBang::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[child_result]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        before do
          allow_service_as_success!(Usual::TestKit::Rspec::AllowServiceAsSuccessBang::Example2Child) do
            {
              data: "New data!"
            }
          end
        end

        it_behaves_like "success result class"

        it "does not raise error" do
          expect { perform }.not_to raise_error
        end

        it "returns success of child class", :aggregate_failures do
          result = perform

          # NOTE: Checking the `with_output` chain.
          expect(result.child_result).to(
            be_success_service
              .with_output(:data, "New data!")
          )

          # NOTE: Checking the `with_outputs` chain.
          expect(result.child_result).to(
            be_success_service
              .with_outputs(
                data: "New data!"
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
                    internals: %i[],
                    outputs: %i[child_result]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        before do
          allow_service_as_success!(Usual::TestKit::Rspec::AllowServiceAsSuccessBang::Example2Child) do
            {
              data: "New data!"
            }
          end
        end

        it_behaves_like "success result class"

        it "returns success of child class", :aggregate_failures do
          result = perform

          # NOTE: Checking the `with_output` chain.
          expect(result.child_result).to(
            be_success_service
              .with_output(:data, "New data!")
          )

          # NOTE: Checking the `with_outputs` chain.
          expect(result.child_result).to(
            be_success_service
              .with_outputs(
                data: "New data!"
              )
          )
        end
      end
    end
  end
end
