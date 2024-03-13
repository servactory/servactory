# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module ConsistsOf
      class Example1 < ApplicationService::Base
        input :ids, type: Array

        internal :ids, type: Set

        make :assign_internal

        private

        def assign_internal
          internals.ids = inputs.ids
        end
      end
    end
  end
end
