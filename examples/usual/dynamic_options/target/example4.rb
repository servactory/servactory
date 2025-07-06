# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example4 < ApplicationService::Base
        class MyFirstService; end # rubocop:disable Lint/EmptyClass

        input :service_class,
              type: Class,
              target: {
                in: MyFirstService,
                message: "Custom error"
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
