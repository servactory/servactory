# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) for failure testing
        class Example4Child < ApplicationService::Base
          input :order_id, type: String

          output :order_status, type: Symbol
          output :shipped_at, type: [Time, NilClass]

          make :check_order

          private

          def check_order
            outputs.order_status = :shipped
            outputs.shipped_at = Time.now
          end
        end

        # Parent service (tested, handles child failures)
        class Example4 < ApplicationService::Base
          input :order_id, type: String

          output :tracking_status, type: Symbol
          output :error_message, type: [String, NilClass]

          make :track_order

          private

          def track_order
            result = Example4Child.call(order_id: inputs.order_id)

            if result.success?
              outputs.tracking_status = result.order_status
              outputs.error_message = nil
            else
              outputs.tracking_status = :error
              outputs.error_message = result.error.message
            end
          end
        end
      end
    end
  end
end
