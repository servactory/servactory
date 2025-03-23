# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example8 < ApplicationService::Base
        input :event_name,
              type: String,
              inclusion: {
                in: %w[created rejected approved]
              }

        internal :event_name,
                 type: String,
                 inclusion: {
                   in: %w[rejected approved]
                 }

        output :event_name,
               type: String,
               inclusion: {
                 in: %w[approved]
               }

        make :assign_attributes

        private

        def assign_attributes
          # NOTE: Here we check how `inclusion` works for `internal` and `output`
          internals.event_name = inputs.event_name
          outputs.event_name = internals.event_name
        end
      end
    end
  end
end
