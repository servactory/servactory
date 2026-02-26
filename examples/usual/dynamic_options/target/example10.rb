# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Target
      class Example10 < ApplicationService::Base
        class TargetA; end # rubocop:disable Lint/EmptyClass
        class TargetB; end # rubocop:disable Lint/EmptyClass

        # NOTE: Option `target` is not specifically used here.
        input :service_class, type: Class

        output :service_class,
               type: Class,
               target: {
                 in: [TargetA, TargetB],
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
