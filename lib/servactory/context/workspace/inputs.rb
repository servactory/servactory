# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Inputs
        def initialize(context:, collection_of_inputs:)
          @context = context
          @collection_of_inputs = collection_of_inputs

          define_attribute_methods!
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
            raise_error_for(:fetch, name)
          end
        end

        def respond_to_missing?(*)
          false
        end

        private

        def define_attribute_methods!
          @collection_of_inputs.each do |input|
            define_singleton_method(input.internal_name) do
              fetch_value(attribute: input)
            end

            next unless @context.config.predicate_methods_enabled

            define_singleton_method(:"#{input.internal_name}?") do
              fetch_predicate(attribute: input)
            end
          end
        end

        def fetch_value(attribute:)
          value = @context.send(:servactory_service_warehouse).fetch_input(attribute.name)

          if attribute.optional? && !attribute.default.nil? && !Servactory::Utils.value_present?(value)
            value = attribute.default
          end

          prepare = attribute.prepare[:in]
          value = prepare.call(value: value) if prepare

          value
        end

        def fetch_predicate(attribute:)
          Servactory::Utils.query_attribute(fetch_value(attribute: attribute))
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
