# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example19 < ApplicationService::Base
        input :digit, type: Integer, inclusion: { in: 1...10 }

        output :digit, type: Integer

        make :assign_digit

        private

        def assign_digit
          outputs.digit = inputs.digit
        end
      end
    end
  end
end
