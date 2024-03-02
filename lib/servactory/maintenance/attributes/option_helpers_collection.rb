# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class OptionHelpersCollection
        extend Forwardable
        def_delegators :@collection, :<<, :find, :merge

        def initialize(collection = Set.new)
          @collection = collection
        end

        def find_by(name:)
          find { |helper| helper.name == name }
        end
      end
    end
  end
end
