# frozen_string_literal: true

module Usual
  module Async
    class Example1 < ApplicationService::Base
      input :id, type: Integer

      output :id, type: Integer

      make :perform

      private

      def perform
        sleep 3

        outputs.id = inputs.id
      end
    end
  end
end
