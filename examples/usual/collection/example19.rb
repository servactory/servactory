# frozen_string_literal: true

module Usual
  module Collection
    class Example19 < ApplicationService::Base
      input :ids, type: Array, consists_of: false

      internal :ids, type: Array, consists_of: false

      output :ids, type: Array, consists_of: false
      output :first_id, type: String

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
