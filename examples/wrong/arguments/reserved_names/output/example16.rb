# frozen_string_literal: true

module Wrong
  module Arguments
    class Example16 < ApplicationService::Base
      output :internals, type: String

      make :assign_internals

      private

      def assign_internals
        outputs.internals = "test"
      end
    end
  end
end
