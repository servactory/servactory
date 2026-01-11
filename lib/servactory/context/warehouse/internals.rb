# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # View for accessing service internal values.
      #
      # ## Purpose
      #
      # Internals provides simple key-value storage for intermediate
      # service state. It references Crate data.
      #
      # ## Important Notes
      #
      # - References Crate#internals hash directly
      # - Inherits fetch/assign from Base
      class Internals < Base; end
    end
  end
end
