# frozen_string_literal: true

module Wrong
  module Arguments
    class Example20 < ApplicationService::Base
      output :failure, type: String

      make :assign_failure

      private

      def assign_failure
        outputs.failure = "test"
      end
    end
  end
end
