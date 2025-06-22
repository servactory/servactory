# frozen_string_literal: true

module Wrong
  module Arguments
    class Example2 < ApplicationService::Base
      output :success, type: [TrueClass, FalseClass]

      make :assign_success

      private

      def assign_success
        outputs.success = true
      end
    end
  end
end
