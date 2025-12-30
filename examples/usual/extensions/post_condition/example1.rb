# frozen_string_literal: true

module Usual
  module Extensions
    module PostCondition
      class Example1 < ApplicationService::Base
        input :amount, type: Integer

        output :total, type: Integer

        post_condition!(:total_positive, message: "Total must be positive") do |outputs|
          outputs.total.positive?
        end

        make :calculate_total

        private

        def calculate_total
          outputs.total = inputs.amount * 2
        end
      end
    end
  end
end
