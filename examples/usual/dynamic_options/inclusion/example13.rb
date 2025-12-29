# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example13 < ApplicationService::Base
        input :priority, type: Integer, inclusion: 1..10

        output :priority, type: Integer

        make :assign_priority

        private

        def assign_priority
          outputs.priority = inputs.priority
        end
      end
    end
  end
end
