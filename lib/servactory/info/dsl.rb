# frozen_string_literal: true

module Servactory
  module Info
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def info
          builder = Builder.build(
            collection_of_inputs:,
            collection_of_internals:,
            collection_of_outputs:,
            config:
          )

          Result.new(builder)
        end
      end
    end
  end
end
