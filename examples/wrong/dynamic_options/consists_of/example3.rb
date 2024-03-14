# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module ConsistsOf
      class Example3 < ApplicationService::Base
        internal :ids, type: Array, consists_of: String

        make :assign_internal

        private

        def assign_internal
          internals.ids = [
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4",
            "",
            "b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81"
          ]
        end
      end
    end
  end
end
