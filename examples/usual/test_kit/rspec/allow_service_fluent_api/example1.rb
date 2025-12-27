# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked)
        class Example1Child < ApplicationService::Base
          input :amount, type: Integer

          output :transaction_id, type: String
          output :status, type: Symbol

          make :process

          private

          def process
            outputs.transaction_id = "txn_#{inputs.amount}"
            outputs.status = :completed
          end
        end

        # Parent service (tested, calls child)
        class Example1 < ApplicationService::Base
          input :amount, type: Integer

          output :payment_status, type: Symbol
          output :payment_transaction_id, type: String

          make :process_payment

          private

          def process_payment
            result = Example1Child.call(amount: inputs.amount)

            fail!(message: result.error.message) if result.failure?

            outputs.payment_status = result.status
            outputs.payment_transaction_id = result.transaction_id
          end
        end
      end
    end
  end
end
