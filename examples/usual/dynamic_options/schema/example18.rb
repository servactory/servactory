# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example18Payload
        extend Forwardable

        def_delegators :@attributes, :fetch, :[], :[]=

        def initialize(attributes = {})
          @attributes = attributes.dup
        end
      end

      class Example18GrandParent < ApplicationService::Base
        configuration do
          hash_mode_class_names([Example18Payload])
        end
      end

      class Example18Parent < Example18GrandParent
      end

      class Example18 < Example18Parent
        input :payload,
              type: Example18Payload,
              schema: {
                first_name: { type: String },
                middle_name: { type: String, required: false, default: "Unknown" }
              }

        output :payload, type: Example18Payload

        make :assign_output

        private

        def assign_output
          outputs.payload = inputs.payload
        end
      end
    end
  end
end
