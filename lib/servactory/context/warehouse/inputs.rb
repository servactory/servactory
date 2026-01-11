# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      class Inputs < Base
        def initialize(context, arguments = {})
          @context = context

          super(arguments)
        end

        def names
          @arguments.keys
        end

        def merge!(arguments)
          @arguments.merge!(arguments)
        end

        ##########################################################################

        def method_missing(name, *_args)
          predicate = @context.config.predicate_methods_enabled && name.end_with?("?")

          input_name = predicate ? name.to_s.chomp("?").to_sym : name

          input_value = @arguments.fetch(input_name) { raise_error_for(input_name) }

          predicate ? Servactory::Utils.query_attribute(input_value) : input_value
        end

        def respond_to_missing?(name, *)
          @arguments.fetch(name) { raise_error_for(name) }
        end

        ##########################################################################

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
