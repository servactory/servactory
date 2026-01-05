# frozen_string_literal: true

module Servactory
  module Stroma
    module Exceptions
      # Raised when attempting to modify a finalized registry
      #
      # ## Purpose
      #
      # Indicates that the Stroma::Registry has been finalized and cannot accept
      # new module registrations. The registry is finalized once during gem
      # initialization and remains immutable thereafter.
      #
      # ## Usage
      #
      # Raised when attempting to register modules after finalize!:
      #
      # ```ruby
      # Servactory::Stroma::Registry.finalize!
      # Servactory::Stroma::Registry.register(:custom, CustomModule)
      # # Raises: Servactory::Stroma::Exceptions::RegistryFrozen
      # ```
      #
      # ## Integration
      #
      # This exception typically indicates a programming error - module
      # registration should only occur during application boot, before
      # any service classes are defined.
      class RegistryFrozen < Base
      end
    end
  end
end
