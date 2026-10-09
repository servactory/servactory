# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example13 < ApplicationService::Base
        configuration do
          internal_option_helpers(
            [
              Servactory::ToolKit::DynamicOptions::Target.use(:expect)
            ]
          )
        end

        class TargetA; end # rubocop:disable Lint/EmptyClass
        class TargetB; end # rubocop:disable Lint/EmptyClass

        internal :service_class,
                 type: Class,
                 expect: {
                   in: [TargetA, TargetB],
                   message: "Internal custom error"
                 }

        output :result, type: String

        make :assign_internal
        make :assign_result

        private

        def assign_internal
          internals.service_class = TargetA
        end

        def assign_result
          outputs.result = internals.service_class.name
        end
      end
    end
  end
end
