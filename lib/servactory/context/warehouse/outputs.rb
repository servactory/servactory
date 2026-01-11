# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # Storage view for service output values.
      #
      # ## Purpose
      #
      # Outputs provides storage for service result values with iteration
      # support via each_pair delegation. Used by Result class to build
      # output hash.
      #
      # ## Important Notes
      #
      # - References Storage#outputs hash directly
      # - Delegates each_pair for Result building
      # - Inherits fetch/assign from Base
      class Outputs < Base
        extend Forwardable

        # Creates outputs view with shared storage reference.
        #
        # @param storage_outputs [Hash] Reference to Storage#outputs
        # @return [Outputs] New outputs view
        def initialize(storage_outputs)
          super(storage_outputs)
        end

        def_delegators :@arguments, :each_pair
      end
    end
  end
end
