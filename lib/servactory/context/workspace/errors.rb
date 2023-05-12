# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Errors
        # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
        extend Forwardable
        def_delegators :@collection, :<<, :to_a, :filter, :reject, :empty?, :first

        def initialize(collection = [])
          @collection = collection
        end

        def not_blank_and_uniq
          Errors.new(reject(&:blank?).uniq)
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
