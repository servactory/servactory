# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # View for accessing service input values.
      #
      # ## Purpose
      #
      # Inputs provides access to service input data with dynamic method access,
      # predicate support, and error handling. It references Crate data
      # instead of creating its own.
      class Inputs < Base
        # Creates inputs view referencing Crate data.
        #
        # @param context [Object] Service context for error handling
        # @param arguments [Hash] Reference to Crate#inputs
        # @return [Inputs] New inputs view
        def initialize(context, arguments)
          @context = context

          super(arguments)
        end

        # Returns array of input names.
        #
        # @return [Array<Symbol>] Input names
        def names
          @arguments.keys
        end

        # Merges new arguments into storage and defines accessor methods.
        #
        # @param arguments [Hash] Input name-value pairs to merge
        # @return [void]
        def merge!(arguments)
          @arguments.merge!(arguments)
          define_methods_for!(arguments)
        end

        # Raises error for any method call not pre-defined as a singleton accessor.
        #
        # Supports predicate methods when enabled in config.
        #
        # @param name [Symbol] Method name (input or predicate)
        # @param _args [Array] Method arguments (unused)
        # @raise [Exception] Failure exception for undefined input
        def method_missing(name, *_args)
          predicate = @context.config.predicate_methods_enabled && name.end_with?("?")
          input_name = predicate ? name.to_s.chomp("?").to_sym : name
          raise_error_for(input_name)
        end

        # Returns false since all valid methods are defined as singleton methods.
        #
        # @return [Boolean] Always false
        def respond_to_missing?(*)
          false
        end

        private

        # Defines singleton accessor methods for given arguments.
        #
        # @param arguments [Hash] Input name-value pairs to define methods for
        # @return [void]
        def define_methods_for!(arguments)
          arguments.each_key do |name|
            define_singleton_method(name) do
              @arguments.fetch(name) { raise_error_for(name) }
            end

            next unless @context.config.predicate_methods_enabled

            define_singleton_method(:"#{name}?") do
              Servactory::Utils.query_attribute(@arguments.fetch(name) { raise_error_for(name) })
            end
          end
        end

        # Raises error for undefined input.
        #
        # @param input_name [Symbol] Name of undefined input
        # @raise [Exception] Failure exception with localized message
        def raise_error_for(input_name)
          message_text = @context.send(:servactory_service_info).translate(
            "inputs.undefined.for_fetch",
            input_name:
          )

          @context.fail_input!(input_name, message: message_text)
        end
      end
    end
  end
end
