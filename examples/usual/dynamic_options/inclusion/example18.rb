# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example18 < ApplicationService::Base
        input :limited_number, type: Integer, inclusion: { in: ..100 }

        output :limited_number, type: Integer

        make :assign_limited_number

        private

        def assign_limited_number
          outputs.limited_number = inputs.limited_number
        end
      end
    end
  end
end
