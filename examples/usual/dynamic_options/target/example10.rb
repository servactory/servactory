# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example10 < ApplicationService::Base
        MyClass1 = Struct.new(:id, keyword_init: true)
        MyClass2 = Struct.new(:id, keyword_init: true)

        input :service_class, type: Class

        output :service_class,
               type: Class,
               target: {
                 in: [MyClass1, MyClass2],
                 message: "Output custom error"
               }

        make :assign_output

        private

        def assign_output
          outputs.service_class = inputs.service_class
        end
      end
    end
  end
end
