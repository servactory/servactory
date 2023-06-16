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
            inputs: collection_of_inputs.names,
            internals: collection_of_internals.names,
            outputs: collection_of_outputs.names
          )
        end
      end
    end
  end
end
