# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Helpers::MockExecutor, type: :service do
  let(:rspec_context) { self }

  # Service with AlternativeService::Exceptions::Failure as failure_class
  let(:alternative_service_class) do
    Class.new(AlternativeService::Base)
  end

  # Service with ApplicationService::Exceptions::Failure as failure_class
  let(:application_service_class) do
    Class.new(ApplicationService::Base)
  end

  describe "#valid_exception_type?" do
    describe "differentiated validation strategy" do
      context "for .call (non-bang) method" do
        it "accepts exception from exact failure_class" do
          expect do
            config = Servactory::TestKit::Rspec::Helpers::ServiceMockConfig.new(
              service_class: alternative_service_class
            )
            config.method_type = :call
            config.result_type = :failure
            config.exception = AlternativeService::Exceptions::Failure.new(message: "Exact class")

            described_class.new(
              service_class: alternative_service_class,
              configs: [config],
              rspec_context:
            ).execute
          end.not_to raise_error
        end

        it "accepts exception from sibling Servactory::Exceptions::Failure subclass (relaxed validation)" do
          expect do
            config = Servactory::TestKit::Rspec::Helpers::ServiceMockConfig.new(
              service_class: alternative_service_class
            )
            config.method_type = :call
            config.result_type = :failure
            # Using ApplicationService::Exceptions::Failure for AlternativeService child
            # This is a sibling class (both inherit from Servactory::Exceptions::Failure)
            config.exception = ApplicationService::Exceptions::Failure.new(message: "Sibling class")

            described_class.new(
              service_class: alternative_service_class,
              configs: [config],
              rspec_context:
            ).execute
          end.not_to raise_error
        end

        it "rejects exception not inheriting from Servactory::Exceptions::Failure" do
          expect do
            config = Servactory::TestKit::Rspec::Helpers::ServiceMockConfig.new(
              service_class: alternative_service_class
            )
            config.method_type = :call
            config.result_type = :failure
            config.exception = StandardError.new("Not a Servactory failure")

            described_class.new(
              service_class: alternative_service_class,
              configs: [config],
              rspec_context:
            ).execute
          end.to raise_error(ArgumentError, /Invalid exception type for failure mock/)
        end
      end

      context "for .call! (bang) method" do
        it "accepts exception from exact failure_class (strict validation)" do
          expect do
            config = Servactory::TestKit::Rspec::Helpers::ServiceMockConfig.new(
              service_class: alternative_service_class
            )
            config.method_type = :call!
            config.result_type = :failure
            config.exception = AlternativeService::Exceptions::Failure.new(message: "Exact class")

            described_class.new(
              service_class: alternative_service_class,
              configs: [config],
              rspec_context:
            ).execute
          end.not_to raise_error
        end

        it "rejects exception from sibling Servactory::Exceptions::Failure subclass (strict validation)" do
          expect do
            config = Servactory::TestKit::Rspec::Helpers::ServiceMockConfig.new(
              service_class: alternative_service_class
            )
            config.method_type = :call!
            config.result_type = :failure
            # Using ApplicationService::Exceptions::Failure for AlternativeService child
            config.exception = ApplicationService::Exceptions::Failure.new(message: "Wrong class")

            described_class.new(
              service_class: alternative_service_class,
              configs: [config],
              rspec_context:
            ).execute
          end.to raise_error(ArgumentError, /Invalid exception type for failure mock/)
        end
      end
    end

    describe "validation rationale" do
      # These tests document WHY differentiated validation exists

      context "semantic justification for relaxed .call validation" do
        it "accepts sibling class because .call wraps exception in Result (never raised)" do
          # When using .call, the exception is:
          # 1. NOT raised (it's wrapped in Result object)
          # 2. Only accessed via result.error.message, result.error.type, result.error.meta
          # 3. Type is semantically irrelevant for .call consumers
          #
          # Therefore, any Servactory::Exceptions::Failure subclass works fine.
          expect do
            config = Servactory::TestKit::Rspec::Helpers::ServiceMockConfig.new(
              service_class: alternative_service_class
            )
            config.method_type = :call
            config.result_type = :failure
            config.exception = ApplicationService::Exceptions::Failure.new(
              message: "Sibling failure - type doesn't matter for .call"
            )

            described_class.new(
              service_class: alternative_service_class,
              configs: [config],
              rspec_context:
            ).execute
          end.not_to raise_error
        end
      end

      context "semantic justification for strict .call! validation" do
        it "rejects sibling class because .call! raises exception (rescue clauses matter)" do
          # When using .call!, the exception is:
          # 1. RAISED and can be caught with rescue
          # 2. rescue AlternativeService::Exceptions::Failure won't catch ApplicationService::Exceptions::Failure
          # 3. Type IS semantically important for .call! consumers
          #
          # Therefore, only the exact failure_class or its subclasses should be accepted.
          expect do
            config = Servactory::TestKit::Rspec::Helpers::ServiceMockConfig.new(
              service_class: alternative_service_class
            )
            config.method_type = :call!
            config.result_type = :failure
            config.exception = ApplicationService::Exceptions::Failure.new(
              message: "Sibling failure - type MATTERS for .call!"
            )

            described_class.new(
              service_class: alternative_service_class,
              configs: [config],
              rspec_context:
            ).execute
          end.to raise_error(ArgumentError, /Invalid exception type for failure mock/)
        end
      end
    end
  end
end
