# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example11 < ApplicationService::Base
        class MyFirstService; end # rubocop:disable Lint/EmptyClass
        class MySecondService; end # rubocop:disable Lint/EmptyClass

        # NOTE: Option `target` is not specifically used here.
        input :service_class, type: Class

        internal :service_class,
                 type: Class,
                 expect: {
                   in: [MyFirstService, MySecondService],
                   message: lambda do |internal:, value:, option_value:, **|
                     "Internal `#{internal.name}`: #{value.inspect} is not allowed. " \
                       "Allowed: #{Array(option_value).map(&:name).join(', ')}"
                   end
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
