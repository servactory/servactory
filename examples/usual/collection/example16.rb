# frozen_string_literal: true

module Usual
  module Collection
    class Example16 < ApplicationService::Base
      input :ids, type: Array, consists_of: [String, Integer]

      internal :ids, type: Array, consists_of: [String, Integer]

      output :ids, type: Array, consists_of: [String, Integer]
      output :first_id, type: [String, Integer]

      make :assign_internal
      make :assign_output
      make :assign_first_id

      private

      def assign_internal
        internals.ids = inputs.ids
      end

      def assign_output
        outputs.ids = internals.ids
      end

      def assign_first_id
        outputs.first_id = outputs.ids.first
      end
    end
  end
end
