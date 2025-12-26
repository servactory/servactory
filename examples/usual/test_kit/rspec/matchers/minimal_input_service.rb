# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class MinimalInputService < ApplicationService::Base
          input :name, type: String
          input :age, type: Integer, required: false, default: 18
          input :email, type: String, required: true
          input :tags, type: Array, consists_of: String
          input :status, type: Symbol, inclusion: %i[active inactive]
          input :config, type: Hash, schema: { key: { type: String } }
          input :score, type: Integer, must: { be_positive: ->(value:, **) { value.positive? } }
          input :options, type: Hash, target: %i[sidekiq]

          def call
            # minimal implementation
          end
        end
      end
    end
  end
end
