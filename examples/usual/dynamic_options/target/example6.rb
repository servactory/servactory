# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example6 < ApplicationService::Base
        class TargetA; end # rubocop:disable Lint/EmptyClass
        class TargetB; end # rubocop:disable Lint/EmptyClass

        input :service_class,
              type: Class,
              target: {
                in: [TargetA, TargetB],
                message: lambda do |input:, value:, option_value:, **|
                  "Input `#{input.name}`: `#{value}` is not allowed. " \
                    "Allowed: #{Array(option_value).map(&:name).join(', ')}"
                end
              }

        output :result, type: String

        make :assign_result

        private

        def assign_result
          outputs.result = inputs.service_class.name
        end
      end
    end
  end
end
