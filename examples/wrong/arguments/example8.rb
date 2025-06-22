# frozen_string_literal: true

module Wrong
  module Arguments
    class Example8 < ApplicationService::Base
      internal :internals, type: String

      output :result, type: String

      make :assign_result

      private

      def assign_result
        outputs.result = internals.internals
      end
    end
  end
end
