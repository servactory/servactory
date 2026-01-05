# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class CustomMessageService < ApplicationService::Base
          input :config,
                type: Hash,
                schema: {
                  is: { key: { type: String } },
                  message: "Config schema validation failed"
                }

          input :status,
                type: Symbol,
                inclusion: {
                  in: %i[active inactive],
                  message: "Status must be active or inactive"
                }

          def call
            # minimal implementation
          end
        end
      end
    end
  end
end
