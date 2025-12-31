# frozen_string_literal: true

module Servactory
  module Stroma
    module Exceptions
      # Raised when using an invalid hook target key
      #
      # ## Purpose
      #
      # Indicates that an unknown key was used as a hook target in the
      # extensions block. Only registered DSL module keys can be used
      # as hook targets.
      #
      # ## Usage
      #
      # Raised when using an invalid key in extensions block:
      #
      # ```ruby
      # class ApplicationService::Base
      #   include Servactory::DSL
      #
      #   extensions do
      #     before :unknown_key, SomeModule
      #     # Raises: Servactory::Stroma::Exceptions::UnknownHookTarget
      #   end
      # end
      # ```
      #
      # ## Integration
      #
      # Valid hook target keys are determined by registered DSL modules:
      # :configuration, :info, :context, :inputs, :internals, :outputs, :actions
      #
      # Check Registry.keys for the list of valid targets.
      class UnknownHookTarget < Base
      end
    end
  end
end
