# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class ProcMessageService < ApplicationService::Base
          input :status,
                type: Symbol,
                inclusion: {
                  in: %i[active inactive],
                  message: lambda do |input:, value:, option_value:, **|
                    "Input `#{input.name}` must be one of #{option_value.inspect}, got #{value.inspect}"
                  end
                }

          input :ids,
                type: Array,
                consists_of: {
                  type: Integer,
                  message: lambda do |service:, input:, **|
                    "[#{service.class_name}] Input `#{input.name}` must contain Integer values"
                  end
                }

          input :config,
                type: Hash,
                schema: {
                  is: { key: { type: String } },
                  message: lambda do |input:, key_name:, **|
                    "Input `#{input.name}` is invalid#{" at `#{key_name}`" if key_name}"
                  end
                }

          internal :tags,
                   type: Array,
                   consists_of: {
                     type: String,
                     message: lambda do |internal:, **|
                       "Internal attribute `#{internal.name}` must contain String values"
                     end
                   }

          make :assign_tags

          private

          def assign_tags
            internals.tags = inputs.ids.map(&:to_s)
          end
        end
      end
    end
  end
end
