# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example5 < ApplicationService::Base
        input :ids,
              type: Array,
              consists_of: {
                type: String,
                message: lambda do |input:, option_value:, **|
                  "Input `#{input.name}` must be an array of `#{Array(option_value).join(', ')}`"
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
end
