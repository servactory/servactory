# frozen_string_literal: true

module Servactory
  module Stroma
    # Represents a registered DSL entry in the Stroma registry.
    #
    # ## Purpose
    #
    # Immutable value object that holds information about a DSL module
    # registered in the Stroma system. Each entry has a unique key
    # and references a Module that will be included in service classes.
    #
    # ## Attributes
    #
    # - `key` (Symbol): Unique identifier for the DSL module (:inputs, :outputs, :actions)
    # - `extension` (Module): The actual DSL module to be included
    #
    # ## Usage
    #
    # Entries are created internally by Registry.register:
    #
    # ```ruby
    # Stroma::Registry.register(:inputs, Servactory::Inputs::DSL)
    # # Creates: Entry.new(key: :inputs, extension: Servactory::Inputs::DSL)
    # ```
    #
    # ## Immutability
    #
    # Entry is immutable (Data object) - once created, it cannot be modified.
    Entry = Data.define(:key, :extension)
  end
end
