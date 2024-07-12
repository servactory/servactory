# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example3 < ApplicationService::Base
        internal :number, type: Integer, divisible_by: nil

        make :assign_internal

        private

        def assign_internal
          internals.number = 10
        end
      end
    end
  end
end
