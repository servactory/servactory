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
              work = input.class::Actor.new(input)
              inclusion = input.collection_of_options.find_by(name: :inclusion)
              must = input.collection_of_options.find_by(name: :must)

              [
                input.name,
                {
                  work: work,
                  types: input.types,
                  required: input.required,
                  default: input.default,
                  inclusion: inclusion.body,
                  must: must.body
                }
              ]
            end,

            internals: collection_of_internals.to_h do |internal|
              work = internal.class::Work.new(internal)
              inclusion = internal.collection_of_options.find_by(name: :inclusion)
              must = internal.collection_of_options.find_by(name: :must)

              [
                internal.name,
                {
                  work: work,
                  types: internal.types,
                  inclusion: inclusion.body,
                  must: must.body
                }
              ]
            end,

            outputs: collection_of_outputs.to_h do |output|
              work = output.class::Work.new(output)
              inclusion = output.collection_of_options.find_by(name: :inclusion)
              must = output.collection_of_options.find_by(name: :must)

              [
                output.name,
                {
                  work: work,
                  types: output.types,
                  inclusion: inclusion.body,
                  must: must.body
                }
              ]
            end
          )
        end
      end
    end
  end
end
