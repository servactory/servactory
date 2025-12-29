# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Inclusion
      class Example7 < ApplicationService::Base
        input :value, type: Integer, inclusion: { in: 1..10 }

        output :value, type: Integer

        make :assign_value

        private

        def assign_value
          # NOTE: This example demonstrates error when value is out of range
          outputs.value = inputs.value
        end
      end
    end
  end
end
