# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      class Outputs < Base
        extend Forwardable

        def_delegators :@arguments, :each_pair
      end
    end
  end
end
