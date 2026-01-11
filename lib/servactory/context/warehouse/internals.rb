# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # Storage view for service internal values.
      #
      # ## Purpose
      #
      # Internals provides simple key-value storage for intermediate
      # service state. It references a shared storage hash.
      #
      # ## Important Notes
      #
      # - References Storage#internals hash directly
      # - Inherits fetch/assign from Base
      class Internals < Base; end
    end
  end
end
