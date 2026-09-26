# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module ConsistsOf
      class Example9 < ApplicationService::Base
        output :ids, type: String, consists_of: String

        make :assign_output

        private

        def assign_output
          outputs.ids = "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3"
        end
      end
    end
  end
end
