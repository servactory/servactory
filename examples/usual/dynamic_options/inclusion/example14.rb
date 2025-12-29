# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example14 < ApplicationService::Base
        input :level, type: Integer, inclusion: { in: 1..5 }

        output :level, type: Integer

        make :assign_level

        private

        def assign_level
          outputs.level = inputs.level
        end
      end
    end
  end
end
