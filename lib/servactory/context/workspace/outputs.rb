# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Outputs
        def initialize(context:, collection_of_outputs:)
          @context = context
          @collection_of_outputs = collection_of_outputs
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

        def method_missing(name, *args)
          if name.to_s.end_with?("=")
            prepared_name = name.to_s.delete("=").to_sym

            setter_with(prepared_name: prepared_name, value: args.pop) { raise_error_for(:setter, prepared_name) }
          else
            getter_with(name: name) { raise_error_for(:getter, name) }
          end
        end

        def respond_to_missing?(name, *)
          @collection_of_outputs.names.include?(name) || super
        end

        private

        def setter_with(prepared_name:, value:, &block) # rubocop:disable Lint/UnusedMethodArgument
          return yield unless @collection_of_outputs.names.include?(prepared_name)

          output = @collection_of_outputs.find_by(name: prepared_name)

          return yield if output.nil?

          Servactory::Maintenance::Attributes::Tools::Validation.validate!(
            context: @context,
            attribute: output,
            value: value
          )

          @context.send(:servactory_service_storage).assign_output(output.name, value)
        end

        def getter_with(name:, &block) # rubocop:disable Lint/UnusedMethodArgument
          output_name = name.to_s.chomp("?").to_sym
          output = @collection_of_outputs.find_by(name: output_name)

          return yield if output.nil?

          output_value = @context.send(:servactory_service_storage).fetch_output(output.name)

          if name.to_s.end_with?("?")
            Servactory::Utils.query_attribute(output_value)
          else
            output_value
          end
        end

        def raise_error_for(type, name)
          message_text = I18n.t(
            "servactory.outputs.undefined.#{type}",
            service_class_name: @context.class.name,
            output_name: name
          )

          raise @context.class.config.output_error_class.new(message: message_text)
        end
      end
    end
  end
end
