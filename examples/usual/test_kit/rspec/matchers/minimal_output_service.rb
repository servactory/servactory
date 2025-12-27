# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class MinimalOutputService < ApplicationService::Base
          input :value, type: String

          output :result, type: String
          output :items, type: Array

          def call
            outputs.result = inputs.value
            outputs.items = [1, 2, 3]
          end
        end
      end
    end
  end
end
