# frozen_string_literal: true

module Wrong
  module Extensions
    module PostCondition
      class Example1 < ApplicationService::Base
        input :amount, type: Integer

        output :total, type: Integer

        post_condition! :total_positive,
                        message: "Total must be positive" do
          outputs.total.positive?
        end

        make :calculate_total

        private

        def calculate_total
          outputs.total = inputs.amount - 200
        end
      end
    end
  end
end
