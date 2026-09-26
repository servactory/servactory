# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example10 < ApplicationService::Base
        internal :number, type: Float, divisible_by: -1.0e16

        make :assign_internal

        private

        def assign_internal
          internals.number = 1.0
        end
      end
    end
  end
end
