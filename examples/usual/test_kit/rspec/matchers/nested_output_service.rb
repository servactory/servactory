# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class NestedOutputService < ApplicationService::Base
          output :response, type: OpenStruct

          def call
            outputs.response = OpenStruct.new(
              data: OpenStruct.new(
                items: [1, 2, 3],
                meta: { count: 3 }
              )
            )
          end
        end
      end
    end
  end
end
