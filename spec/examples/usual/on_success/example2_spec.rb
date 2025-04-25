# frozen_string_literal: true

RSpec.describe Usual::OnSuccess::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number_1 number_2]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it "calls expected methods", :aggregate_failures do
          result = perform

          performed_methods = []

          expect do
            result.on_success do |outputs:|
              performed_methods.push(:call_method_on_success)
              performed_methods.push(outputs.number_1)
              performed_methods.push(outputs.number_2)
            end.on_failure(:all) do |**| # rubocop:disable Style/MultilineBlockChain
              performed_methods.push(:call_method_on_failure_all)
            end
          end.to(
            change { performed_methods }.from([]).to(
              [:call_method_on_success, 1, 2]
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
                    outputs: %i[number_1 number_2]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it "calls expected methods", :aggregate_failures do
          result = perform

          performed_methods = []

          expect do
            result.on_success do |outputs:|
              performed_methods.push(:call_method_on_success)
              performed_methods.push(outputs.number_1)
              performed_methods.push(outputs.number_2)
            end.on_failure(:all) do |**| # rubocop:disable Style/MultilineBlockChain
              performed_methods.push(:call_method_on_failure_all)
            end
          end.to(
            change { performed_methods }.from([]).to(
              [:call_method_on_success, 1, 2]
            )
          )
        end
      end
    end
  end
end
