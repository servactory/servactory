# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Basic
          class Example1 < ApplicationService::Base
            input :boolean, type: String, format: :boolean

            output :boolean, type: String

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
