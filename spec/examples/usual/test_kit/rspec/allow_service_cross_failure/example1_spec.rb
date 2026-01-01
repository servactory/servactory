# frozen_string_literal: true

# This spec demonstrates differentiated exception type validation:
# - `.call` (non-bang): Relaxed validation - accepts any Servactory::Exceptions::Failure subclass
# - `.call!` (bang): Strict validation - requires the service's configured failure_class
#
# The child service uses AlternativeService::Base with AlternativeService::Exceptions::Failure.
# The parent service uses ApplicationService::Base with ApplicationService::Exceptions::Failure.
# These are sibling classes - both inherit from Servactory::Exceptions::Failure but NOT from each other.
#
# Important: fail_result! creates a NEW exception with the PARENT's failure_class.
# So when testing .call! on the parent, the raised exception is ApplicationService::Exceptions::Failure,
# not AlternativeService::Exceptions::Failure.
RSpec.describe Usual::TestKit::Rspec::AllowServiceCrossFailure::Example1, type: :service do
  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[]

    context "when mocking child with sibling failure class (relaxed validation)" do
      # Using ApplicationService::Exceptions::Failure to mock AlternativeService::Base child.
      # This works because .call uses relaxed validation - any Servactory::Exceptions::Failure subclass is accepted.
      before do
        allow_service_as_failure(Usual::TestKit::Rspec::AllowServiceCrossFailure::Example1Child) do
          ApplicationService::Exceptions::Failure.new(message: "Cross-service error from sibling class")
        end
      end

      it "accepts any Servactory::Exceptions::Failure subclass" do
        expect(perform).to(
          be_failure_service
            .with(ApplicationService::Exceptions::Failure)
            .type(:base)
            .message("Cross-service error from sibling class")
            .meta(nil)
        )
      end
    end

    context "when mocking child with exact failure class" do
      # Using AlternativeService::Exceptions::Failure - the exact failure_class of the child service.
      before do
        allow_service_as_failure(Usual::TestKit::Rspec::AllowServiceCrossFailure::Example1Child) do
          AlternativeService::Exceptions::Failure.new(message: "Cross-service error from exact class")
        end
      end

      it "also works with exact failure class" do
        expect(perform).to(
          be_failure_service
            .with(ApplicationService::Exceptions::Failure)
            .type(:base)
            .message("Cross-service error from exact class")
            .meta(nil)
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[]

    context "when mocking child with exact failure class" do
      # Using AlternativeService::Exceptions::Failure - the exact failure_class of the child service.
      # The child's .call mock accepts it (relaxed validation for .call).
      # Parent then calls fail_result! which creates ApplicationService::Exceptions::Failure.
      before do
        allow_service_as_failure(Usual::TestKit::Rspec::AllowServiceCrossFailure::Example1Child) do
          AlternativeService::Exceptions::Failure.new(message: "Cross-service error with exact class")
        end
      end

      it "parent raises its own failure_class with child's message", :aggregate_failures do
        expect { perform }.to(
          raise_error do |exception|
            # Parent service uses fail_result! which creates NEW exception with PARENT's failure_class
            expect(exception).to be_a(ApplicationService::Exceptions::Failure)
            expect(exception.type).to eq(:base)
            expect(exception.message).to eq("Cross-service error with exact class")
            expect(exception.meta).to be_nil
          end
        )
      end
    end

    context "when mocking child with sibling failure class" do
      # Using ApplicationService::Exceptions::Failure to mock AlternativeService::Base child.
      # The child's .call mock accepts it (relaxed validation for .call).
      # Parent then calls fail_result! which creates ApplicationService::Exceptions::Failure.
      before do
        allow_service_as_failure(Usual::TestKit::Rspec::AllowServiceCrossFailure::Example1Child) do
          ApplicationService::Exceptions::Failure.new(message: "Cross-service error from sibling class")
        end
      end

      it "parent raises its own failure_class with child's message", :aggregate_failures do
        expect { perform }.to(
          raise_error do |exception|
            expect(exception).to be_a(ApplicationService::Exceptions::Failure)
            expect(exception.type).to eq(:base)
            expect(exception.message).to eq("Cross-service error from sibling class")
            expect(exception.meta).to be_nil
          end
        )
      end
    end
  end

  # Separate tests for strict validation behavior (allow_service_as_failure!)
  describe "strict validation for allow_service_as_failure!" do
    context "when mocking with exact failure class" do
      it "allows mocking with exact failure_class" do
        expect do
          allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceCrossFailure::Example1Child) do
            AlternativeService::Exceptions::Failure.new(message: "Exact class")
          end
        end.not_to raise_error
      end
    end

    context "when mocking with wrong failure class" do
      # Using ApplicationService::Exceptions::Failure to mock AlternativeService::Base child.
      # This should FAIL because .call! uses strict validation - requires exact failure_class.
      it "raises ArgumentError for mismatched failure class" do
        expect do
          allow_service_as_failure!(Usual::TestKit::Rspec::AllowServiceCrossFailure::Example1Child) do
            ApplicationService::Exceptions::Failure.new(message: "Wrong class error")
          end
        end.to raise_error(
          ArgumentError,
          /Invalid exception type for failure mock/
        )
      end
    end
  end
end
