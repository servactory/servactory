# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceAsSuccess::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[child_result]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        before do
          allow_service_as_success(Usual::TestKit::Rspec::AllowServiceAsSuccess::Example2Child) do
            {
              data: "New data!"
            }
          end
        end

        include_examples "success result class"

        it "returns success result child class", :aggregate_failures do
          result = perform

          expect(result.child_result).to be_a(Servactory::Result)
          expect(result.child_result.success?).to be(true)
          expect(result.child_result.failure?).to be(false)
          expect(result.child_result.data).to eq("New data!")
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[child_result]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        before do
          allow_service_as_success(Usual::TestKit::Rspec::AllowServiceAsSuccess::Example2Child) do
            {
              data: "New data!"
            }
          end
        end

        include_examples "success result class"

        it "returns success result child class", :aggregate_failures do
          result = perform

          expect(result.child_result).to be_a(Servactory::Result)
          expect(result.child_result.success?).to be(true)
          expect(result.child_result.failure?).to be(false)
          expect(result.child_result.data).to eq("New data!")
        end

        it "returns success of child class" do
          result = perform

          expect(result.child_result).to be_success_service.with(data: "New data!")
        end
      end
    end
  end
end
