# frozen_string_literal: true

module Servactory
  module InputArguments
    module Tools
      class CheckErrors
        # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
        extend Forwardable
        def_delegators :@collection, :merge, :reject

        def initialize(*)
          @collection = Set.new
        end
      end
    end
  end
end
