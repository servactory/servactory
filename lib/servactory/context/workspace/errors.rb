# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Errors
        # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
        extend Forwardable
        def_delegators :@collection, :<<, :filter, :reject, :empty?, :first

        def initialize(collection = Set.new)
          @collection = collection
        end

        def not_blank
          Errors.new(reject(&:blank?))
        end

        def for_fails
          filtered = filter { |error| error.type == :fail }

          Errors.new(filtered)
        end

        def for_inputs
          filtered = filter { |error| error.type == :inputs }

          Errors.new(filtered)
        end
      end
    end
  end
end
