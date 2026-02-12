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

        # Merges new arguments into storage.
        #
        # @param arguments [Hash] Input name-value pairs to merge
        # @return [Hash] Updated arguments hash
        def merge!(arguments)
          @arguments.merge!(arguments)
        end

        # Delegates method calls to stored inputs.
        #
        # Supports predicate methods when enabled in config.
        #
        # @param name [Symbol] Method name (input or predicate)
        # @param _args [Array] Method arguments (unused)
        # @return [Object] Input value or predicate result
        def method_missing(name, *_args)
          predicate = @context.config.predicate_methods_enabled && name.end_with?("?")

          input_name = predicate ? name.to_s.chomp("?").to_sym : name

          input_value = @arguments.fetch(input_name) { raise_error_for(input_name) }

          predicate ? Servactory::Utils.query_attribute(input_value) : input_value
        end

        # Checks if method corresponds to stored input.
        #
        # @param name [Symbol] Method name to check
        # @return [Boolean] True if input exists for this method
        def respond_to_missing?(name, *)
          input_name = name.to_s.chomp("?").to_sym
          @arguments.key?(input_name) || @arguments.key?(name) || super
        end

        private

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
