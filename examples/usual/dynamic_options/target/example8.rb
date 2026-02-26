# frozen_string_literal: true

# TODO: Need to add a wrong example to test the exception.
module Usual
  module DynamicOptions
    module Target
      class Example8 < ApplicationService::Base
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
