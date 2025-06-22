# frozen_string_literal: true

module Wrong
  module Arguments
    class Example15 < ApplicationService::Base
      output :internal, type: String

      make :assign_internal

      private

      def assign_internal
        outputs.internal = "test"
      end
    end
  end
end 