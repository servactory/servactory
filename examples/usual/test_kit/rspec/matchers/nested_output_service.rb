# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class NestedOutputService < ApplicationService::Base
          ResponseData = Struct.new(:items, :meta, keyword_init: true)
          Response = Struct.new(:data, keyword_init: true)

          output :response, type: Response

          def call
            outputs.response = Response.new(
              data: ResponseData.new(
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
