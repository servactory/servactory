# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Schema
      class Example18Payload < ::Hash; end

      class Example18 < ApplicationService::Base
        configuration do
          hash_mode_class_names([Example18Payload])
        end

        input :payload,
              type: [String, Symbol],
              schema: {
                name: { type: String }
              }

        def call; end
      end
    end
  end
end
