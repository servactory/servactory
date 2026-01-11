# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # Orchestrator for service context data.
      #
      # ## Purpose
      #
      # Setup manages a unified Crate instance and provides the public
      # interface for accessing inputs, internals, and outputs. It creates
      # view objects lazily on first access.
      class Setup
        # Creates setup with unified crate.
        #
        # @param context [Object] Service context
        # @return [Setup] New setup instance
        def initialize(context)
          @context = context
          @crate = Crate.new
        end

        # Merges input arguments into storage.
        #
        # @param arguments [Hash] Input name-value pairs
        # @return [Hash] Updated inputs hash
        def assign_inputs(arguments)
          inputs.merge!(arguments)
        end

        # Retrieves input value by name.
        #
        # @param name [Symbol] Input name
        # @return [Object, nil] Input value or nil
        def fetch_input(name)
          inputs.fetch(name, nil)
        end

        # Stores internal value by name.
        #
        # @param name [Symbol] Internal name
        # @param value [Object] Value to store
        # @return [Object] Stored value
        def assign_internal(name, value)
          internals.assign(name, value)
        end

        # Retrieves internal value by name.
        #
        # @param name [Symbol] Internal name
        # @return [Object, nil] Internal value or nil
        def fetch_internal(name)
          internals.fetch(name, nil)
        end

        # Stores output value by name.
        #
        # @param name [Symbol] Output name
        # @param value [Object] Value to store
        # @return [Object] Stored value
        def assign_output(name, value)
          outputs.assign(name, value)
        end

        # Retrieves output value by name.
        #
        # @param name [Symbol] Output name
        # @return [Object, nil] Output value or nil
        def fetch_output(name)
          outputs.fetch(name, nil)
        end

        # Returns inputs view object.
        #
        # @return [Inputs] Inputs view
        def inputs
          @inputs ||= Inputs.new(@context, @crate.inputs)
        end

        # Returns internals view object.
        #
        # @return [Internals] Internals view
        def internals
          @internals ||= Internals.new(@crate.internals)
        end

        # Returns outputs view object.
        #
        # @return [Outputs] Outputs view
        def outputs
          @outputs ||= Outputs.new(@crate.outputs)
        end
      end
    end
  end
end
