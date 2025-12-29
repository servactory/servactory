# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) with strongly typed outputs
        class Example9Child < ApplicationService::Base
          input :order_id, type: String

          output :order_number, type: Integer
          output :customer_name, type: String
          output :total_amount, type: Float

          make :fetch_order

          private

          def fetch_order
            outputs.order_number = 1001
            outputs.customer_name = "Test Customer"
            outputs.total_amount = 99.99
          end
        end

        # Parent service (tested, calls child for order details)
        class Example9 < ApplicationService::Base
          input :order_id, type: String

          output :order_summary, type: String

          make :build_summary

          private

          def build_summary
            result = Example9Child.call!(order_id: inputs.order_id)

            outputs.order_summary = "Order ##{result.order_number}: " \
                                    "#{result.customer_name} - $#{result.total_amount}"
          end
        end
      end
    end
  end
end
