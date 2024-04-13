# frozen_string_literal: true

module Servactory
  module Info
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def info # rubocop:disable Metrics/MethodLength
          Servactory::Info::Result.new(
            inputs: collection_of_inputs.to_h do |input|
              [
                input.name,
                {
                  types: input.types,
                  required: input.required,
                  default: input.default
                }
              ]
            end,

            internals: collection_of_internals.to_h do |internal|
              [
                internal.name,
                {
                  types: internal.types
                }
              ]
            end,

            outputs: collection_of_outputs.to_h do |output|
              [
                output.name,
                {
                  types: output.types
                }
              ]
            end
          )
        end
      end
    end
  end
end
