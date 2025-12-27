# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class SuccessService < ApplicationService::Base
          input :data, type: String

          output :result, type: String
          output :status, type: Symbol

          def call
            outputs.result = inputs.data.upcase
            outputs.status = :completed
          end
        end
      end
    end
  end
end
