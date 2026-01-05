# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceAsSuccess
        # Child service (mocked) for testing with: parameter
        class Example4Child < ApplicationService::Base
          input :amount, type: Integer
          input :currency, type: String

          output :formatted_amount, type: String

          make :format

          private

          def format
            outputs.formatted_amount = "#{inputs.amount} #{inputs.currency}"
          end
        end

        # Parent service (tested, calls child with specific inputs)
        class Example4 < ApplicationService::Base
          input :amount, type: Integer
          input :currency, type: String

          output :display_value, type: String

          make :process_amount

          private

          def process_amount
            result = Example4Child.call(amount: inputs.amount, currency: inputs.currency)

            outputs.display_value = result.formatted_amount
          end
        end
      end
    end
  end
end
