# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example18 < ApplicationService::Base
        input :ids, type: Array, consists_of: String

        internal :ids,
                 type: Array,
                 consists_of: {
                   type: String,
                   message: lambda do |internal:, option_value:, **|
                     "Internal `#{internal.name}` must be an array of `#{Array(option_value).join(', ')}`"
                   end
                 }

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
end
