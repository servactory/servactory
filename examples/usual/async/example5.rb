# frozen_string_literal: true

module Usual
  module Async
    class Example5 < ApplicationService::Base
      input :index, type: Integer

      internal :computed, type: String

      output :value, type: String

      make :compute
      make :assign

      private

      def compute
        sleep(rand(0.01..0.05))

        internals.computed = "result-#{inputs.index}"
      end

      def assign
        outputs.value = internals.computed
      end
    end
  end
end
