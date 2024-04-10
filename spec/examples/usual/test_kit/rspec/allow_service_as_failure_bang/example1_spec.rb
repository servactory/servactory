# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        before do
          allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example1Child) do
            ApplicationService::Exceptions::Failure.new(message: "Some overridden error")
          end
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
          allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceAsFailureBang::Example1Child) do
            ApplicationService::Exceptions::Failure.new(message: "Some overridden error")
          end
        end

        it "returns expected failure" do
          expect(perform).to(
            be_failure_service
              .as(ApplicationService::Exceptions::Failure)
              .with_type(:base)
              .with_message("Some overridden error")
              .with_meta(nil)
          )
        end
      end
    end
  end
end
