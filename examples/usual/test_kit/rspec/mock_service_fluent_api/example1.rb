# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module MockServiceFluentApi
        # Service with inputs and outputs for testing mock_service fluent API
        class Example1Child < ApplicationService::Base
          input :amount, type: Integer

          output :transaction_id, type: String
          output :status, type: Symbol

          make :process_payment

          private

          def process_payment
            outputs.transaction_id = "txn_#{inputs.amount}"
            outputs.status = :completed
          end
        end

        # Parent service that calls Example1Child
        class Example1 < ApplicationService::Base
          input :amount, type: Integer

          output :child_result, type: Servactory::Result

          make :call_child_service

          private

          def call_child_service
            outputs.child_result = Example1Child.call(amount: inputs.amount)

            fail_result!(outputs.child_result) if outputs.child_result.failure?
          end
        end
      end
    end
  end
end
