# frozen_string_literal: true

module Wrong
  module Arguments
    class Example24 < ApplicationService::Base
      output :error, type: String

      make :assign_error

      private

      def assign_error
        outputs.error = "test"
      end
    end
  end
end
