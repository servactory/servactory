# frozen_string_literal: true

RSpec.describe Usual::OnSuccess::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "calls expected methods", :aggregate_failures do
          result = perform

          performed_methods = []

          expect do
            result.on_success do
              performed_methods.push(:call_method_on_success)
            end.on_failure(:all) do |**| # rubocop:disable Style/MultilineBlockChain
              performed_methods.push(:call_method_on_failure_all)
            end
          end.to(
            change { performed_methods }.from([]).to(
              %i[call_method_on_success]
            )
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
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "calls expected methods", :aggregate_failures do
          result = perform

          performed_methods = []

          expect do
            result.on_success do
              performed_methods.push(:call_method_on_success)
            end.on_failure(:all) do |**| # rubocop:disable Style/MultilineBlockChain
              performed_methods.push(:call_method_on_failure_all)
            end
          end.to(
            change { performed_methods }.from([]).to(
              %i[call_method_on_success]
            )
          )
        end
      end
    end
  end
end
