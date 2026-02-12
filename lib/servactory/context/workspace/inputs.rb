# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Inputs
        def initialize(context:, collection_of_inputs:)
          @context = context
          @collection_of_inputs = collection_of_inputs
        end

        def only(*names)
          @collection_of_inputs
            .only(*names)
            .to_h { |input| [input.internal_name, send(input.internal_name)] }
        end

        def except(*names)
          @collection_of_inputs
            .except(*names)
            .to_h { |input| [input.internal_name, send(input.internal_name)] }
        end

        def method_missing(name, *_args)
          if name.to_s.end_with?("=")
            prepared_name = name.to_s.delete("=").to_sym

            raise_error_for(:assign, prepared_name)
          else
            fetch_with(name:) { raise_error_for(:fetch, name) }
          end
        end

        def respond_to_missing?(name, *)
          resolve_input(name) || super
        end

        private

        def fetch_with(name:, &_block)
          predicate = @context.config.predicate_methods_enabled && name.end_with?("?")

          input_name = predicate ? name.to_s.chomp("?").to_sym : name

          input = @collection_of_inputs.find_by(name: input_name)

          return yield if input.nil?

          value = fetch_value(attribute: input)

          predicate ? Servactory::Utils.query_attribute(value) : value
        end

        def fetch_value(attribute:)
          value = @context.send(:servactory_service_warehouse).fetch_input(attribute.name)

          if attribute.optional? && !attribute.default.nil? && !Servactory::Utils.value_present?(value)
            value = attribute.default
          end

          prepare = attribute.prepare[:in]
          value = prepare.call(value:) if prepare

          value
        end

        def resolve_input(name)
          return true if @collection_of_inputs.find_by(name:)

          @context.config.predicate_methods_enabled &&
            name.to_s.end_with?("?") &&
            @collection_of_inputs.find_by(name: name.to_s.chomp("?").to_sym)
        end

        def raise_error_for(type, name)
          message_text = @context.send(:servactory_service_info).translate(
            "inputs.undefined.for_#{type}",
            input_name: name
          )

          @context.fail_input!(name, message: message_text)
        end
      end
    end
  end
end
