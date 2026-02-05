# frozen_string_literal: true

module Usual
  module Async
    class Example3 < ApplicationService::Base
      input :id, type: Integer
      input :should_fail, type: [TrueClass, FalseClass], default: false

      output :id, type: Integer

      make :maybe_fail
      make :perform

      private

      def maybe_fail
        sleep 1

        return unless inputs.should_fail

        fail!(message: "Intentional failure for id=#{inputs.id}")
      end

      def perform
        outputs.id = inputs.id
      end
    end
  end
end
