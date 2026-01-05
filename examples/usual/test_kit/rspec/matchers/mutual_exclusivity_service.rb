# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class MutualExclusivityService < ApplicationService::Base
          input :required_field, type: String, required: true
          input :optional_field, type: String, required: false

          def call
            # minimal implementation
          end
        end
      end
    end
  end
end
