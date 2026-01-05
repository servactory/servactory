# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Fluent API for mocking Servactory services in RSpec tests.
        #
        # ## Purpose
        #
        # Provides modern fluent builder interface for configuring service mocks
        # with chainable method calls. This is the recommended API for new tests.
        #
        # ## Usage
        #
        # Include in RSpec configuration via the main Helpers module:
        #
        # ```ruby
        # RSpec.configure do |config|
        #   config.include Servactory::TestKit::Rspec::Helpers, type: :service
        # end
        # ```
        #
        # ## Available Methods
        #
        # - `allow_service(ServiceClass)` - mock `.call` method (returns Result)
        # - `allow_service!(ServiceClass)` - mock `.call!` method (raises on failure)
        #
        # ## Examples
        #
        # ```ruby
        # # Mock successful service call with outputs
        # allow_service(PaymentService)
        #   .succeeds(transaction_id: "txn_123", status: :completed)
        #
        # # Mock with input matching
        # allow_service(PaymentService)
        #   .with(amount: 100)
        #   .succeeds(transaction_id: "txn_100")
        #
        # # Mock failure
        # allow_service(PaymentService)
        #   .fails(type: :payment_declined, message: "Card declined")
        #
        # # Sequential returns
        # allow_service(PaymentService)
        #   .succeeds(status: :pending)
        #   .then_succeeds(status: :completed)
        # ```
        #
        # @see ServiceMockBuilder for full fluent API documentation
        module Fluent
          # Start building a service mock with fluent API for .call method.
          #
          # When service fails, returns Result with `.error` attribute.
          #
          # @param service_class [Class] The service class to mock
          # @return [ServiceMockBuilder] Builder for fluent configuration
          #
          # @example Success mock
          #   allow_service(PaymentService)
          #     .succeeds(transaction_id: "txn_123", status: :completed)
          #
          # @example Success with input matching
          #   allow_service(PaymentService)
          #     .with(amount: 100)
          #     .succeeds(transaction_id: "txn_123")
          #
          # @example Failure mock
          #   allow_service(PaymentService)
          #     .fails(type: :payment_declined, message: "Card declined")
          #
          # @example Sequential returns
          #   allow_service(PaymentService)
          #     .succeeds(status: :pending)
          #     .then_succeeds(status: :completed)
          #     .then_fails(type: :timeout, message: "Request timed out")
          #
          def allow_service(service_class)
            Helpers::ServiceMockBuilder.new(service_class, method_type: :call, rspec_context: self)
          end

          # Start building a service mock with fluent API for .call! method.
          #
          # When service fails, raises exception.
          #
          # @param service_class [Class] The service class to mock
          # @return [ServiceMockBuilder] Builder for fluent configuration
          #
          # @example Success mock for call!
          #   allow_service!(PaymentService)
          #     .succeeds(transaction_id: "txn_123", status: :completed)
          #
          # @example Failure mock for call! (raises exception)
          #   allow_service!(PaymentService)
          #     .fails(type: :payment_declined, message: "Insufficient funds")
          #
          # @example Sequential returns
          #   allow_service!(RetryService)
          #     .succeeds(status: :pending)
          #     .then_fails(type: :timeout, message: "Request timed out")
          #
          def allow_service!(service_class)
            Helpers::ServiceMockBuilder.new(service_class, method_type: :call!, rspec_context: self)
          end
        end
      end
    end
  end
end
