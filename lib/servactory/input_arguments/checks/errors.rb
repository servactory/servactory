# frozen_string_literal: true

module Servactory
  module InputArguments
    module Checks
      class Errors
        # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
        extend Forwardable
        def_delegators :@collection, :add, :to_a

        def initialize(*)
          @collection = Set.new
        end
      end
    end
  end
end
