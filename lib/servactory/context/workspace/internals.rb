# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Internals
        def initialize(context:, collection_of_internals:)
          @context = context
          @collection_of_internals = collection_of_internals
        end

        def only(*names)
          @collection_of_internals
            .only(*names)
            .to_h { |internal| [internal.name, send(internal.name)] }
        end

        def except(*names)
          @collection_of_internals
            .except(*names)
            .to_h { |internal| [internal.name, send(internal.name)] }
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
          @collection_of_internals.names.include?(name) || super
        end

        private

        def setter_with(prepared_name:, value:, &block) # rubocop:disable Lint/UnusedMethodArgument
          return yield unless @collection_of_internals.names.include?(prepared_name)

          internal = @collection_of_internals.find_by(name: prepared_name) # ::Servactory::Internals::Internal

          return yield if internal.nil?

          Servactory::Maintenance::Attributes::Tools::Validation.validate!(
            context: @context,
            attribute: internal,
            value: value
          )

          @context.send(:servactory_service_store).assign_internal(internal.name, value)
        end

        def getter_with(name:, &block) # rubocop:disable Lint/UnusedMethodArgument
          internal_name = name.to_s.chomp("?").to_sym
          internal = @collection_of_internals.find_by(name: internal_name)

          return yield if internal.nil?

          internal_value = @context.send(:servactory_service_store).fetch_internal(internal.name)

          if name.to_s.end_with?("?")
            Servactory::Utils.query_attribute(internal_value)
          else
            internal_value
          end
        end

        def raise_error_for(type, name)
          message_text = I18n.t(
            "servactory.internals.undefined.#{type}",
            service_class_name: @context.class.name,
            internal_name: name
          )

          raise @context.class.config.input_exception_class.new(message: message_text)
        end
      end
    end
  end
end
