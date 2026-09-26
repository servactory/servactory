# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module ConsistsOf
      class Example8 < ApplicationService::Base
        internal :ids, type: String, consists_of: String

        make :assign_internal

        private

        def assign_internal
          internals.ids = "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3"
        end
      end
    end
  end
end
