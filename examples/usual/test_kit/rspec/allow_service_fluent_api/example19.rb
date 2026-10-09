# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked or passed through, reconfigured after it was called)
        class Example19Child < ApplicationService::Base
          input :amount, type: Integer

          output :discount, type: Integer

          make :calculate_discount

          private

          def calculate_discount
            outputs.discount = inputs.amount / 20
          end
        end

        # Parent service (tested, calls child with its input)
        class Example19 < ApplicationService::Base
          input :amount, type: Integer

          output :price, type: Integer

          make :calculate_price

          private

          def calculate_price
            result = Example19Child.call(amount: inputs.amount)

            fail!(message: result.error.message) if result.failure?

            outputs.price = inputs.amount - result.discount
          end
        end
      end
    end
  end
end
