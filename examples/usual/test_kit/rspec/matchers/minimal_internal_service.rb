# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class MinimalInternalService < ApplicationService::Base
          input :data, type: String

          internal :processed, type: String
          internal :items, type: Array, consists_of: Integer
          internal :metadata, type: Hash, schema: { version: { type: Integer } }

          def call
            internals.processed = inputs.data.upcase
            internals.items = [1, 2, 3]
            internals.metadata = { version: 1 }
          end
        end
      end
    end
  end
end
