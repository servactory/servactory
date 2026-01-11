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
      class Outputs < Base
        extend Forwardable

        def_delegators :@arguments, :each_pair
      end
    end
  end
end
