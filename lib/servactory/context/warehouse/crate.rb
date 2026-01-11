# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # Unified crate for service context data.
      #
      # ## Purpose
      #
      # Crate provides a single object that holds all three data sections
      # (inputs, internals, outputs) in separate hashes. This reduces object
      # allocations compared to creating separate warehouse instances.
      #
      # ## Usage
      #
      # Crate is used internally by Setup class:
      #
      # ```ruby
      # crate = Crate.new
      # crate.inputs[:name] = "value"
      # crate.outputs[:result] = result
      # ```
      class Crate
        attr_reader :inputs,
                    :internals,
                    :outputs

        # Creates new crate with empty sections.
        #
        # @return [Crate] New crate instance
        def initialize
          @inputs = {}
          @internals = {}
          @outputs = {}
        end
      end
    end
  end
end
