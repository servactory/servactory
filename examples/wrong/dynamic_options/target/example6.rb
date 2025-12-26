# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Target
      class Example6 < ApplicationService::Base
        class MyFirstService; end # rubocop:disable Lint/EmptyClass

        input :service_class, type: Class

        output :target_class, type: Class, target: { in: nil }

        make :assign_target_class

        private

        def assign_target_class
          outputs.target_class = inputs.service_class
        end
      end
    end
  end
end
