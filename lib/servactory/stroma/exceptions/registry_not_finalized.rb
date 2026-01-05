# frozen_string_literal: true

module Servactory
  module Stroma
    module Exceptions
      # Raised when accessing registry before finalization
      #
      # ## Purpose
      #
      # Indicates that the Stroma::Registry was accessed before finalize! was called.
      # The registry must be finalized before it can be used to ensure all DSL modules
      # are registered in the correct order.
      #
      # ## Usage
      #
      # Raised when accessing registry methods before finalization:
      #
      # ```ruby
      # # Before finalize! is called
      # Servactory::Stroma::Registry.entries
      # # Raises: Servactory::Stroma::Exceptions::RegistryNotFinalized
      # ```
      #
      # ## Integration
      #
      # This exception typically indicates that Servactory::DSL module was not
      # properly loaded. Ensure servactory gem is properly required before
      # defining service classes.
      class RegistryNotFinalized < Base
      end
    end
  end
end
