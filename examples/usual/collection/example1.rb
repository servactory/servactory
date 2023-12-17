# frozen_string_literal: true

module Usual
  module Collection
    class Example1 < ApplicationService::Base
      input :ids, type: Array

      internal :ids, type: Array

      output :first_id, type: String

      make :assign_internal
      make :assign_first_id

      private

      def assign_internal
        internals.ids = inputs.ids
      end

      def assign_first_id
        outputs.first_id = internals.ids.first
      end
    end
  end
end