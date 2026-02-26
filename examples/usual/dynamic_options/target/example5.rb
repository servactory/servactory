# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example5 < ApplicationService::Base
        class TargetA; end # rubocop:disable Lint/EmptyClass
        class TargetB; end # rubocop:disable Lint/EmptyClass

        input :service_class,
              type: Class,
              target: {
                in: [TargetA, TargetB],
                message: "Custom error for array"
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
