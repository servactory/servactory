# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example15 < ApplicationService::Base
        input :score,
              type: Integer,
              inclusion: {
                in: 0..100,
                message: lambda do |value:, **|
                  value.nil? ? "Score is required" : "Score #{value} must be between 0 and 100"
                end
              }

        output :score, type: Integer

        make :assign_score

        private

        def assign_score
          outputs.score = inputs.score
        end
      end
    end
  end
end
