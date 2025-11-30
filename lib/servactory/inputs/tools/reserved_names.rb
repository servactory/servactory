# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      class ReservedNames < Servactory::Maintenance::Attributes::Tools::ReservedNames
        RESERVED_NAMES = %i[
          input inputs internal internals output outputs
          fail
          success failure
        ].freeze
      end
    end
  end
end
