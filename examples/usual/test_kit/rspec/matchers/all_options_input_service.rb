# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class AllOptionsInputService < ApplicationService::Base
          input :complete,
                type: String,
                required: true,
                default: "default",
                inclusion: %w[a b c default],
                must: { be_lowercase: ->(value:, **) { value == value.downcase } }

          def call
            # minimal implementation
          end
        end
      end
    end
  end
end
