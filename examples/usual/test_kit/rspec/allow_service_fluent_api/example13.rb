# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked or passed through) for input matching order
        class Example13Child < ApplicationService::Base
          input :amount, type: Integer

          output :fee, type: Integer

          make :calculate_fee

          private

          def calculate_fee
            outputs.fee = inputs.amount / 10
          end
        end

        # Parent service (tested, calls child with its input)
        class Example13 < ApplicationService::Base
          input :amount, type: Integer

          output :total, type: Integer

          make :calculate_total

          private

          def calculate_total
            result = Example13Child.call(amount: inputs.amount)

            fail!(message: result.error.message) if result.failure?

            outputs.total = inputs.amount + result.fee
          end
        end
      end
    end
  end
end
