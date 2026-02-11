# frozen_string_literal: true

module Servactory
  module Internals
    # Specialized collection for Internal attributes.
    #
    # Inherits all behavior from the base Attributes::Collection
    # without any overrides.
    class Collection < Servactory::Maintenance::Attributes::Collection
    end
  end
end
