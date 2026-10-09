# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Schema
      class Example13 < ApplicationService::Base
        input :payload,
              type: ::Hash,
              schema: {
                meta: {
                  type: ::Hash,
                  a: { type: String }
                },
                name: { type: String }
              }

        def call; end
      end
    end
  end
end
