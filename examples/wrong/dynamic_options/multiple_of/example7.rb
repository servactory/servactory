# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example7 < ApplicationService::Base
        internal :number, type: Float, divisible_by: -0.1

        make :assign_internal

        private

        def assign_internal
          internals.number = 0.35
        end
      end
    end
  end
end
