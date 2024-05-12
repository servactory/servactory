# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example11 < ApplicationService::Base
        input :ids, type: Array, consists_of: String, required: false, default: []

        internal :ids, type: Array, consists_of: String

        output :ids, type: Array, consists_of: String

        make :assign_internal
        make :assign_output

        private

        def assign_internal
          internals.ids = inputs.ids
        end

        def assign_output
          outputs.ids = internals.ids
        end
      end
    end
  end
end
