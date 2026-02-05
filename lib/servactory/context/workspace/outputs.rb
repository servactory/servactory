# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Outputs
        def initialize(context:, collection_of_outputs:)
          @context = context
          @collection_of_outputs = collection_of_outputs

          define_attribute_methods!
        end

        def only(*names)
          @collection_of_outputs
            .only(*names)
            .to_h { |output| [output.name, send(output.name)] }
        end

        def except(*names)
          @collection_of_outputs
            .except(*names)
            .to_h { |output| [output.name, send(output.name)] }
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

        def define_attribute_methods! # rubocop:disable Metrics/MethodLength
          @collection_of_outputs.each do |output|
            define_singleton_method(output.name) do
              fetch_value(attribute: output)
            end

            define_singleton_method(:"#{output.name}=") do |value|
              assign_value(attribute: output, value:)
            end

            next unless @context.config.predicate_methods_enabled

            define_singleton_method(:"#{output.name}?") do
              fetch_predicate(attribute: output)
            end
          end
        end

        def assign_value(attribute:, value:)
          Servactory::Maintenance::Validations::Performer.validate!(
            context: @context,
            attribute:,
            value:
          )

          @context.send(:servactory_service_warehouse).assign_output(attribute.name, value)
        end

        def fetch_value(attribute:)
          @context.send(:servactory_service_warehouse).fetch_output(attribute.name)
        end

        def fetch_predicate(attribute:)
          Servactory::Utils.query_attribute(fetch_value(attribute:))
        end

        def raise_error_for(type, name)
          message_text = @context.send(:servactory_service_info).translate(
            "outputs.undefined.for_#{type}",
            output_name: name
          )

          @context.fail_output!(name, message: message_text)
        end
      end
    end
  end
end
