# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class MessagesService < ApplicationService::Base
          input :status,
                type: {
                  is: Symbol,
                  message: "Status must be a Symbol"
                },
                inclusion: {
                  in: %i[active inactive],
                  message: "Status must be active or inactive"
                }

          input :kind,
                type: Symbol,
                inclusion: %i[primary secondary]

          input :number,
                type: Integer,
                must: {
                  be_even: {
                    is: ->(value:, **) { value.even? },
                    message: "Number must be even"
                  },
                  be_positive: ->(value:, **) { value.positive? },
                  be_small: {
                    is: ->(value:, **) { value < 100 },
                    message: ->(input:, code:, **) { "Input `#{input.name}` must #{code}" }
                  }
                }

          internal :state,
                   type: {
                     is: Symbol,
                     message: "State must be a Symbol"
                   },
                   inclusion: {
                     in: %i[new done],
                     message: "State must be new or done"
                   }

          internal :count,
                   type: Integer,
                   must: {
                     be_positive: {
                       is: ->(value:, **) { value.positive? },
                       message: ->(internal:, **) { "Internal attribute `#{internal.name}` must be positive" }
                     }
                   }

          def call
            internals.state = :new
            internals.count = 1
          end
        end
      end
    end
  end
end
