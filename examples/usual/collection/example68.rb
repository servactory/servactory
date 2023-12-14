# frozen_string_literal: true

module Usual
  module Collection
    class Example68 < ApplicationService::Base
      input :ids,
            type: Set,
            consists_of: { message: "Input `ids` must be a collection of `String`" }

      output :first_id, type: String

      make :assign_first_id

      private

      def assign_first_id
        outputs.first_id = inputs.ids.first
      end
    end
  end
end
