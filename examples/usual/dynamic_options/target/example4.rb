# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example4 < ApplicationService::Base
        MyClass1 = Struct.new(:id, keyword_init: true)

        input :service_class,
              type: Class,
              target: {
                in: MyClass1,
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
