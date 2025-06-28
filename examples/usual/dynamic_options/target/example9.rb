# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example9 < ApplicationService::Base
        MyClass1 = Struct.new(:id, keyword_init: true)

        input :service_class, type: Class

        output :service_class, type: Class, target: MyClass1

        make :assign_output

        private

        def assign_output
          outputs.service_class = inputs.service_class
        end
      end
    end
  end
end
