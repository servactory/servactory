# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Target
      class Example3 < ApplicationService::Base
        class MyFirstService; end # rubocop:disable Lint/EmptyClass

        input :service_class, type: Class

        internal :target_class, type: Class, expect: nil

        make :assign_target_class

        private

        def assign_target_class
          internals.target_class = inputs.service_class
        end
      end
    end
  end
end
