# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # View for accessing service output values.
      #
      # ## Purpose
      #
      # Outputs provides storage for service result values with iteration
      # support via each_pair delegation. Used by Result class to build
      # output hash.
      #
      # ## Important Notes
      #
      # - References Crate#outputs hash directly
      # - Delegates each_pair for Result building
      # - Inherits fetch/assign from Base
      class Outputs < Base
        extend Forwardable

        def_delegators :@arguments, :each_pair
      end
    end
  end
end
