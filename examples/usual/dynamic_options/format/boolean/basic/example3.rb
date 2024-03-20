# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Basic
          class Example3 < ApplicationService::Base
            input :boolean, type: String

            output :boolean, type: String, format: :boolean

            make :assign_output

            private

            def assign_output
              outputs.boolean = inputs.boolean
            end
          end
        end
      end
    end
  end
end
