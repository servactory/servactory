# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example11 < ApplicationService::Base
        MyClass1 = Struct.new(:id, keyword_init: true)
        MyClass2 = Struct.new(:id, keyword_init: true)

        input :service_class, type: Class

        internal :service_class,
                 type: Class,
                 target: {
                   in: [MyClass1, MyClass2],
                   message: lambda { |internal:, value:, option_value:, **|
                     "Internal `#{internal.name}`: #{value.inspect} is not allowed. " \
                       "Allowed: #{Array(option_value).map(&:name).join(', ')}"
                   }
                 }

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
