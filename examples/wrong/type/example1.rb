# frozen_string_literal: true

module Wrong
  module Type
    class Example1 < ApplicationService::Base
      input :limit,
            type: {
              is: Integer,
              message: lambda do |input:, value:, given_type:, **|
                "Input `#{input.name}` must be an Integer, got `#{value.inspect}` (#{given_type})"
              end
            },
            required: false,
            default: "10"

      output :limit, type: Integer

      make :assign_limit

      private

      def assign_limit
        outputs.limit = inputs.limit
      end
    end
  end
end
