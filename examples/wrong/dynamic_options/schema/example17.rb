# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Schema
      class Example17 < ApplicationService::Base
        input :payload,
              type: String,
              schema: {
                is: {
                  name: { type: String }
                },
                message: lambda do |input:, reason:, key_name:, expected_type:, given_type:, **|
                  "Input `#{input.name}` failed with `#{reason}` for `#{key_name.inspect}`: " \
                    "expected `#{expected_type}`, got `#{given_type}`"
                end
              }

        def call; end
      end
    end
  end
end
