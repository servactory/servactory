# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example7 < ApplicationService::Base
        MyClass1 = Struct.new(:id, keyword_init: true)

        input :service_class, type: Class

        internal :service_class, type: Class, target: MyClass1

        output :result, type: String

        make :assign_internal
        make :assign_result

        private

        def assign_internal
          internals.service_class = inputs.service_class
        end

        def assign_result
          outputs.result = internals.service_class.name
        end
      end
    end
  end
end
