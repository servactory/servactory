# frozen_string_literal: true

module Usual
  module Inclusion
    class Example9 < ApplicationService::Base
      input :event_name,
            type: String,
            inclusion: {
              in: %w[created rejected approved],
              message: lambda do |input:, value:, **|
                value.present? ? "Incorrect `#{input.name}` specified: `#{value}`" : "Event name not specified"
              end
            }

      internal :event_name,
               type: String,
               inclusion: {
                 in: %w[rejected approved],
                 message: lambda do |internal:, value:, **|
                   value.present? ? "Incorrect `#{internal.name}` specified: `#{value}`" : "Event name not specified"
                 end
               }

      output :event_name,
             type: String,
             inclusion: {
               in: %w[approved],
               message: lambda do |output:, value:, **|
                 value.present? ? "Incorrect `#{output.name}` specified: `#{value}`" : "Event name not specified"
               end
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
