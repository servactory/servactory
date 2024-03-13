# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example8 < ApplicationService::Base
        input :ids, as: :array_of_ids, type: Array, consists_of: String

        internal :array_of_ids, type: Array, consists_of: String

        output :array_of_ids, type: Array, consists_of: String
        output :first_id, type: String

        make :assign_internal
        make :assign_output
        make :assign_first_id

        private

        def assign_internal
          internals.array_of_ids = inputs.array_of_ids
        end

        def assign_output
          outputs.array_of_ids = internals.array_of_ids
        end

        def assign_first_id
          outputs.first_id = outputs.array_of_ids.first
        end
      end
    end
  end
end
