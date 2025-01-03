# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      class Inputs
        def initialize(context, arguments = {})
          @context = context
          @arguments = arguments
        end

        def names
          @arguments.keys
        end

        # QUESTION
        def to_hash
          @arguments
        end
        alias to_h to_hash

        # def fetch!(name)
        #   @arguments.fetch(name)
        # end

        def fetch(name, default_value)
          @arguments.fetch(name, default_value)
        end

        def assign(key, value)
          @arguments[key] = value
        end

        def merge!(arguments)
          @arguments.merge!(arguments)
        end

        ##########################################################################

        def method_missing(name, *_args)
          input_name = @context.class.config.predicate_methods_enabled? ? name.to_s.chomp("?").to_sym : name

          input_value = @arguments.fetch(input_name) { raise_error_for(input_name) }

          if name.to_s.end_with?("?") && @context.class.config.predicate_methods_enabled?
            Servactory::Utils.query_attribute(input_value)
          else
            input_value
          end
        end

        def respond_to_missing?(name, *)
          @arguments.try(name) { raise_error_for(name) }
        end

        ##########################################################################

        def raise_error_for(input_name)
          message_text = @context.send(:servactory_service_info).translate(
            "inputs.undefined.for_fetch",
            input_name:
          )

          raise @context.class.config.input_exception_class.new(
            context: @context,
            message: message_text,
            input_name:
          )
        end
      end
    end
  end
end
