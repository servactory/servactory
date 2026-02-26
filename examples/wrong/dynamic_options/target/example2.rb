# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Target
      class Example2 < ApplicationService::Base
        class TargetA; end # rubocop:disable Lint/EmptyClass

        input :service_class, type: Class, target: { in: nil }

        make :perform

        private

        def perform
          # ...
        end
      end
    end
  end
end
