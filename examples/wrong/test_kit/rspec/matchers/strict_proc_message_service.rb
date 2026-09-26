# frozen_string_literal: true

module Wrong
  module TestKit
    module Rspec
      module Matchers
        class StrictProcMessageService < ApplicationService::Base
          class Handler; end # rubocop:disable Lint/EmptyClass

          input :count,
                type: {
                  is: Integer,
                  message: ->(input:) { "Input `#{input.name}` is invalid" }
                }

          input :status,
                type: Symbol,
                inclusion: {
                  in: %i[active inactive],
                  message: ->(input:) { "Input `#{input.name}` is invalid" }
                }

          input :ids,
                type: Array,
                consists_of: {
                  type: Integer,
                  message: ->(input:) { "Input `#{input.name}` is invalid" }
                }

          input :config,
                type: Hash,
                schema: {
                  is: { key: { type: String } },
                  message: ->(input:) { "Input `#{input.name}` is invalid" }
                }

          input :handler,
                type: Class,
                target: {
                  in: [Handler],
                  message: ->(input:) { "Input `#{input.name}` is invalid" }
                }

          def call; end
        end
      end
    end
  end
end
