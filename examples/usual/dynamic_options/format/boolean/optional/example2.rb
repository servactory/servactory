# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Optional
          class Example2 < ApplicationService::Base
            input :boolean, type: String, required: false

            internal :boolean, type: [String, NilClass], check_format: :boolean

            output :boolean, type: [String, NilClass]

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.boolean = inputs.boolean
            end

            def assign_output
              outputs.boolean = internals.boolean
            end
          end
        end
      end
    end
  end
end
