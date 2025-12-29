# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example20 < ApplicationService::Base
        input :ids, type: Array, consists_of: String

        output :ids,
               type: Array,
               consists_of: {
                 type: String,
                 message: lambda do |output:, option_value:, **|
                   "Output `#{output.name}` must be an array of `#{Array(option_value).join(', ')}`"
                 end
               }

        make :assign_output

        private

        def assign_output
          outputs.ids = inputs.ids
        end
      end
    end
  end
end
