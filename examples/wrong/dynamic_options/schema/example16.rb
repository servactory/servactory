# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Schema
      class Example16 < ApplicationService::Base
        output :payload,
               type: String,
               schema: {
                 name: { type: String }
               }

        make :assign_output

        private

        def assign_output
          outputs.payload = "John"
        end
      end
    end
  end
end
