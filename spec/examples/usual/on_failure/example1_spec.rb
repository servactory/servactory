# frozen_string_literal: true

RSpec.describe Usual::OnFailure::Example1 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Errors::Failure)
              expect(exception.type).to eq(:validation)
              expect(exception.message).to eq("Validation error")
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
        include_examples "failure result class"

        it "calls expected methods", :aggregate_failures do
          result = perform

          performed_methods = []

          expect do
            result.on_success { performed_methods.push(:call_method_on_success) }
                  .on_failure(:all) { |**| performed_methods.push(:call_method_on_failure_all) }
                  .on_failure(:base) { |**| performed_methods.push(:call_method_on_failure_base) }
                  .on_failure(:validation) { |**| performed_methods.push(:call_method_on_failure_validation) }
          end.to(
            change { performed_methods }.from([]).to(
              %i[call_method_on_failure_all call_method_on_failure_validation]
            )
          )
        end
      end
    end
  end
end
