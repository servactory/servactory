# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example17 < ApplicationService::Base
        input :positive_number, type: Integer, inclusion: { in: 1.. }

        output :positive_number, type: Integer

        make :assign_positive_number

        private

        def assign_positive_number
          outputs.positive_number = inputs.positive_number
        end
      end
    end
  end
end
