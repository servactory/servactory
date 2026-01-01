# frozen_string_literal: true

module Servactory
  module Stroma
    module Exceptions
      # Raised when registering a duplicate key in the registry
      #
      # ## Purpose
      #
      # Indicates that a DSL module key has already been registered.
      # Each DSL module must have a unique key in the registry.
      #
      # ## Usage
      #
      # Raised when attempting to register a duplicate key:
      #
      # ```ruby
      # Servactory::Stroma::Registry.register(:inputs, Inputs::DSL)
      # Servactory::Stroma::Registry.register(:inputs, AnotherModule)
      # # Raises: Servactory::Stroma::Exceptions::KeyAlreadyRegistered
      # ```
      #
      # ## Integration
      #
      # This exception typically indicates a configuration error - each
      # DSL module should only be registered once. Check for duplicate
      # registrations in your initialization code.
      class KeyAlreadyRegistered < Base
      end
    end
  end
end
