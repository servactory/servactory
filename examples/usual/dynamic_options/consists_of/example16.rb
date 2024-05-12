# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example16 < ApplicationService::Base
        input :ids, type: Set, consists_of: String, required: false, default: Set[]

        internal :ids, type: Set, consists_of: String

        output :ids, type: Set, consists_of: String

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
