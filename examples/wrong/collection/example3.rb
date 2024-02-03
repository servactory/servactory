# frozen_string_literal: true

module Wrong
  module Collection
    class Example3 < ApplicationService::Base
      internal :ids, type: Array

      output :ids, type: Set

      make :assign_internal
      make :assign_output

      private

      def assign_internal
        internals.ids = %w[
          6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
          bdd30bb6-c6ab-448d-8302-7018de07b9a4
          e864b5e7-e515-4d5e-9a7e-7da440323390
          b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
        ]
      end

      def assign_output
        outputs.ids = internals.ids
      end
    end
  end
end
