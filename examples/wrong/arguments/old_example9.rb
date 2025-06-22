# frozen_string_literal: true

module Wrong
  module Arguments
    class Example10 < ApplicationService::Base
      internal :input, type: String

      output :result, type: String

      make :assign_result

      private

      def assign_result
        outputs.result = internals.input
      end
    end
  end
end 