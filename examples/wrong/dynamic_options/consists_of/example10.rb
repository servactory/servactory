# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module ConsistsOf
      class Example10 < ApplicationService::Base
        input :ids,
              type: String,
              consists_of: {
                type: String,
                message: lambda do |input:, value:, option_value:, reason:, **|
                  "Input `#{input.name}` failed with `#{reason}` for `#{value}`: " \
                    "expected a collection of `#{Array(option_value).join(', ')}`"
                end
              }

        def call; end
      end
    end
  end
end
