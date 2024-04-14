# frozen_string_literal: true

module Servactory
  module Info
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def info # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          Servactory::Info::Result.new(
            inputs: collection_of_inputs.to_h do |input|
              work = input.class::Work.new(input)
              consists_of = input.collection_of_options.find_by(name: :consists_of)
              must = input.collection_of_options.find_by(name: :must)

              [
                input.name,
                {
                  work: work,
                  types: input.types,
                  required: input.required,
                  default: input.default,
                  consists_of: consists_of.body,
                  must: must.body
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
