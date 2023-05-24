# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      class CheckErrors
        # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
        extend Forwardable
        def_delegators :@collection, :merge, :reject, :first, :empty?

        def initialize(collection = Set.new)
          @collection = collection
        end

        def not_blank
          CheckErrors.new(reject(&:blank?))
        end
      end
    end
  end
end
