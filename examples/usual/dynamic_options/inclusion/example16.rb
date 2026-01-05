# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example16 < ApplicationService::Base
        input :number, type: Integer, inclusion: { in: 1..100 }

        internal :adjusted_number, type: Integer, inclusion: { in: 10..50 }

        output :final_number, type: Integer, inclusion: { in: 20..30 }

        make :process_number

        private

        def process_number
          # NOTE: Clamp the input to internal range, then to output range
          internals.adjusted_number = inputs.number.clamp(10, 50)
          outputs.final_number = internals.adjusted_number.clamp(20, 30)
        end
      end
    end
  end
end
