# frozen_string_literal: true

module Servactory
  module Stroma
    module Exceptions
      # Raised when an invalid hook type is provided.
      #
      # ## Purpose
      #
      # Ensures that only valid hook types (:before, :after) are used
      # when creating Servactory::Stroma::Hook objects. Provides fail-fast
      # behavior during class definition rather than silent failures at runtime.
      #
      # ## Usage
      #
      # ```ruby
      # # This will raise InvalidHookType:
      # Servactory::Stroma::Hook.new(
      #   type: :invalid,
      #   target_key: :actions,
      #   extension: MyModule
      # )
      # # => Servactory::Stroma::Exceptions::InvalidHookType:
      # #    Invalid hook type: :invalid. Valid types: :before, :after
      # ```
      class InvalidHookType < Base; end
    end
  end
end
