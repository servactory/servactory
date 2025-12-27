# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) for partial matching
        class Example5Child < ApplicationService::Base
          input :product_id, type: String
          input :quantity, type: Integer
          input :customer_id, type: String

          output :line_total, type: Integer
          output :discount_applied, type: [TrueClass, FalseClass]

          make :calculate

          private

          def calculate
            outputs.line_total = inputs.quantity * 100
            outputs.discount_applied = false
          end
        end

        # Parent service (tested, calls child with multiple inputs)
        class Example5 < ApplicationService::Base
          input :product_id, type: String
          input :quantity, type: Integer
          input :customer_id, type: String

          output :order_total, type: Integer
          output :has_discount, type: [TrueClass, FalseClass]

          make :calculate_order

          private

          def calculate_order
            result = Example5Child.call(
              product_id: inputs.product_id,
              quantity: inputs.quantity,
              customer_id: inputs.customer_id
            )

            if result.success?
              outputs.order_total = result.line_total
              outputs.has_discount = result.discount_applied
            end
          end
        end
      end
    end
  end
end
