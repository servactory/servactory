# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example19 < ApplicationService::Base
        input :ids, type: Array, consists_of: String

        output :ids,
               type: Array,
               consists_of: {
                 type: String,
                 message: "Output `ids` must be an array of `String`"
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
