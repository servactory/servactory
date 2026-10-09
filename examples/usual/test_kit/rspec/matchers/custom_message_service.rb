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

          input :count,
                type: {
                  is: Integer,
                  message: "Count must be an Integer"
                }

          internal :total,
                   type: {
                     is: [Integer, Float],
                     message: "Total must be a number"
                   }

          def call
            # minimal implementation
          end
        end
      end
    end
  end
end
