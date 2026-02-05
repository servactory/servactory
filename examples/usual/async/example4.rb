# frozen_string_literal: true

module Usual
  module Async
    class Example4 < ApplicationService::Base
      input :number, type: Integer

      internal :doubled, type: Integer
      internal :tripled, type: Integer

      output :result, type: Integer

      stage do
        wrap_in ->(methods:, **) { methods.call }

        make :double_number
        make :triple_number
      end

      make :compute_result

      private

      def double_number
        sleep 1

        internals.doubled = inputs.number * 2
      end

      def triple_number
        internals.tripled = inputs.number * 3
      end

      def compute_result
        outputs.result = internals.doubled + internals.tripled
      end
    end
  end
end
