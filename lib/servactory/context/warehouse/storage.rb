# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # Unified storage container for service context data.
      #
      # ## Purpose
      #
      # Storage provides a single object that holds all three data sections
      # (inputs, internals, outputs) in separate hashes. This reduces object
      # allocations compared to creating separate warehouse instances.
      #
      # ## Usage
      #
      # Storage is used internally by Setup class:
      #
      # ```ruby
      # storage = Storage.new
      # storage.inputs[:name] = "value"
      # storage.outputs[:result] = data
      # ```
      #
      # ## Important Notes
      #
      # - This is an internal implementation class
      # - Single instance replaces three separate Base instances
      # - Hashes are exposed directly for performance
      class Storage
        # Creates new storage with empty data sections.
        #
        # @return [Storage] New storage instance
        def initialize
          @inputs = {}
          @internals = {}
          @outputs = {}
        end

        attr_reader :inputs, :internals, :outputs
      end
    end
  end
end
