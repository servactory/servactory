# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Optional
          class Example1 < ApplicationService::Base
            input :boolean, type: String, format: :boolean, required: false

            output :boolean, type: [String, NilClass]

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
