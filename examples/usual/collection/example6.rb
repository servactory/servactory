# frozen_string_literal: true

module Usual
  module Collection
    class Example6 < ApplicationService::Base
      input :ids,
            type: Array,
            consists_of: {
              type: String,
              message: lambda do |input:, expected_type:, **|
                "Input `#{input.name}` must be an array of `#{expected_type}`"
              end
            }

      output :first_id, type: String

      make :assign_first_id

      private

      def assign_first_id
        outputs.first_id = inputs.ids.first
      end
    end
  end
end
