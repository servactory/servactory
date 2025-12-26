# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example6 < ApplicationService::Base
        class MyFirstService; end # rubocop:disable Lint/EmptyClass
        class MySecondService; end # rubocop:disable Lint/EmptyClass

        input :service_class,
              type: Class,
              target: {
                in: [MyFirstService, MySecondService],
                message: lambda { |input:, value:, option_value:, **|
                  "Input `#{input.name}`: `#{value}` is not allowed. " \
                    "Allowed: #{Array(option_value).map(&:name).join(', ')}"
                }
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
