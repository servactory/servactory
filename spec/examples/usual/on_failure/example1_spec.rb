# frozen_string_literal: true

RSpec.describe Usual::OnFailure::Example1 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[some_value]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:validation)
              expect(exception.message).to eq("Validation error")
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
                     outputs: %i[some_value]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        # include_examples "failure result class"

        it "returns failure result class", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result.success?).to be(false)
          expect(result.failure?).to be(true)
          expect(result.failure?(:all)).to be(true)
          expect(result.failure?(:base)).to be(false)
          expect(result.failure?(:validation)).to be(true)
        end

        it "calls expected methods", :aggregate_failures do
          result = perform

          performed_methods = []

          expect do
            result.on_success { performed_methods.push(:call_method_on_success) }
                  .on_failure(:all) { |outputs:, **| performed_methods.push(outputs.some_value) }
                  .on_failure(:base) { |**| performed_methods.push(:call_method_on_failure_base) }
                  .on_failure(:validation) { |**| performed_methods.push(:call_method_on_failure_validation) }
          end.to(
            change { performed_methods }.from([]).to(
              %i[some_value call_method_on_failure_validation]
            )
          )
        end
      end
    end
  end
end
