# frozen_string_literal: true

module Servactory
  module Stroma
    module Exceptions
      # Base exception class for all Stroma-specific exceptions
      #
      # ## Purpose
      #
      # Serves as the parent class for all custom exceptions in the Stroma subsystem.
      # Allows catching all Stroma-related exceptions with a single rescue clause.
      #
      # ## Usage
      #
      # All Stroma exceptions inherit from this base class:
      #
      # ```ruby
      # begin
      #   Stroma::Registry.register(:custom, CustomModule)
      # rescue Servactory::Stroma::Exceptions::Base => e
      #   # Catches any Stroma-specific exception
      #   handle_stroma_error(e)
      # end
      # ```
      #
      # ## Integration
      #
      # Can be used in application error handlers for centralized error handling:
      #
      # ```ruby
      # rescue_from Servactory::Stroma::Exceptions::Base, with: :handle_stroma_error
      # ```
      #
      # ## Subclasses
      #
      # - RegistryFrozen - Raised when modifying a finalized registry
      # - RegistryNotFinalized - Raised when accessing registry before finalization
      # - KeyAlreadyRegistered - Raised when registering a duplicate key
      # - UnknownHookTarget - Raised when using an invalid hook target key
      class Base < StandardError
      end
    end
  end
end
