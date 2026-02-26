# frozen_string_literal: true

# TODO: Need to add a wrong example to test the exception.
module Usual
  module DynamicOptions
    module Target
      class Example9 < ApplicationService::Base
        class TargetA; end # rubocop:disable Lint/EmptyClass

        # NOTE: Option `target` is not specifically used here.
        input :service_class, type: Class

        output :service_class, type: Class, target: TargetA

        make :assign_output

        private

        def assign_output
          outputs.service_class = inputs.service_class
        end
      end
    end
  end
end
