# frozen_string_literal: true

module Servactory
  module Internals
    module Tools
      class ReservedNames < Servactory::Maintenance::Attributes::Tools::ReservedNames
        RESERVED_NAMES = %i[
          input inputs internal internals output outputs
        ].freeze
      end
    end
  end
end
