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

            assign_with(prepared_name:, value: args.pop) { raise_error_for(:assign, prepared_name) }
          else
            fetch_with(name:) { raise_error_for(:fetch, name) }
          end
        end

        def respond_to_missing?(name, *)
          @collection_of_internals.names.include?(name) || super
        end

        private

        def assign_with(prepared_name:, value:, &block) # rubocop:disable Lint/UnusedMethodArgument
          return yield unless @collection_of_internals.names.include?(prepared_name)

          internal = @collection_of_internals.find_by(name: prepared_name) # ::Servactory::Internals::Internal

          return yield if internal.nil?

          Servactory::Maintenance::Attributes::Tools::Validation.validate!(
            context: @context,
            attribute: internal,
            value:
          )

          @context.send(:servactory_service_store).assign_internal(internal.name, value)
        end

        def fetch_with(name:, &block) # rubocop:disable Metrics/AbcSize, Lint/UnusedMethodArgument
          internal_name = @context.class.config.predicate_methods_enabled? ? name.to_s.chomp("?").to_sym : name
          internal = @collection_of_internals.find_by(name: internal_name)

          return yield if internal.nil?

          internal_value = @context.send(:servactory_service_store).fetch_internal(internal.name)

          if name.to_s.end_with?("?") && @context.class.config.predicate_methods_enabled?
            Servactory::Utils.query_attribute(internal_value)
          else
            internal_value
          end
        end

        def raise_error_for(type, name)
          message_text = @context.send(:servactory_service_info).translate(
            "internals.undefined.#{type}",
            internal_name: name
          )

          raise @context.class.config.internal_exception_class.new(message: message_text)
        end
      end
    end
  end
end
