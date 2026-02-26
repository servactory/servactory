# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Target
      class Example4 < ApplicationService::Base
        class TargetA; end # rubocop:disable Lint/EmptyClass

        input :service_class, type: Class

        internal :target_class, type: Class, expect: { in: nil }

        make :assign_target_class

        private

        def assign_target_class
          internals.target_class = inputs.service_class
        end
      end
    end
  end
end
