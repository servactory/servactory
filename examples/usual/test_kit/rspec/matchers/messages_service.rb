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

          internal :state,
                   type: {
                     is: Symbol,
                     message: "State must be a Symbol"
                   },
                   inclusion: {
                     in: %i[new done],
                     message: "State must be new or done"
                   }

          def call
            internals.state = :new
          end
        end
      end
    end
  end
end
