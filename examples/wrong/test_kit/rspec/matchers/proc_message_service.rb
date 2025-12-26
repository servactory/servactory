# frozen_string_literal: true

module Wrong
  module TestKit
    module Rspec
      module Matchers
        class ProcMessageService < ApplicationService::Base
          input :value,
                type: Integer,
                inclusion: {
                  in: [1, 2, 3],
                  message: ->(input:, value:, **) { "#{input.name} got invalid #{value}" }
                }

          def call
            # minimal implementation
          end
        end
      end
    end
  end
end
