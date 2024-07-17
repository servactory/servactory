# frozen_string_literal: true

module Usual
  module Description
    class Example1 < ApplicationService::Base
      input :id, type: String, note: "Payment identifier in an external system"

      output :id, type: String, note: "Payment identifier in an external system"

      make :assign_output

      private

      def assign_output
        outputs.id = inputs.id
      end
    end
  end
end
