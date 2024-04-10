# frozen_string_literal: true

module Servactory
  module Info
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def info
          Servactory::Info::Result.new(
            inputs: collection_of_inputs.to_h { |i| [i.name, { types: i.types, required: i.required }] },
            internals: collection_of_internals.to_h { |i| [i.name, { types: i.types }] },
            outputs: collection_of_outputs.to_h { |o| [o.name, { types: o.types }] }
          )
        end
      end
    end
  end
end
