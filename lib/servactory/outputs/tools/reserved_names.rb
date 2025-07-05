# frozen_string_literal: true

module Servactory
  module Outputs
    module Tools
      class ReservedNames < Servactory::Maintenance::Attributes::Tools::ReservedNames
        RESERVED_NAMES = %i[
          input inputs internal internals output outputs
          info
          success failure
          error
        ].freeze
      end
    end
  end
end
