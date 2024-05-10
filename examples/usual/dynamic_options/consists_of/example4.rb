# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example4 < ApplicationService::Base
        input :ids,
              type: Array,
              consists_of: {
                type: String,
                message: "Input `ids` must be an array of `String`"
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
end
