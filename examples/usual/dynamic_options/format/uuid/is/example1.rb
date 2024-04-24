# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Is
          class Example1 < ApplicationService::Base
            input :uuid, type: String, format: { is: :uuid }

            output :uuid, type: String

            make :assign_output

            private

            def assign_output
              outputs.uuid = inputs.uuid
            end
          end
        end
      end
    end
  end
end
