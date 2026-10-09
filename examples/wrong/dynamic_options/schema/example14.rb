# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Schema
      class Example14 < ApplicationService::Base
        input :payload,
              type: String,
              schema: {
                name: { type: String }
              }

        def call; end
      end
    end
  end
end
