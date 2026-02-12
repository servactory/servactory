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
          resolve_internal(name) || super
        end

        private

        def validated_attributes
          @validated_attributes ||= Set.new
        end

        def assign_with(prepared_name:, value:, &_block)
          internal = @collection_of_internals.find_by(name: prepared_name)

          return yield if internal.nil?

          validated_attributes.delete(internal.name)

          Servactory::Maintenance::Validations::Performer.validate!(
            context: @context,
            attribute: internal,
            value:
          )

          @context.send(:servactory_service_warehouse).assign_internal(internal.name, value)

          validated_attributes << internal.name
        end

        def fetch_with(name:, &_block)
          predicate = @context.config.predicate_methods_enabled && name.end_with?("?")

          internal_name = predicate ? name.to_s.chomp("?").to_sym : name
          internal = @collection_of_internals.find_by(name: internal_name)

          return yield if internal.nil?

          internal_value = fetch_value(attribute: internal)

          predicate ? Servactory::Utils.query_attribute(internal_value) : internal_value
        end

        def fetch_value(attribute:)
          value = @context.send(:servactory_service_warehouse).fetch_internal(attribute.name)

          if validated_attributes.exclude?(attribute.name)
            Servactory::Maintenance::Validations::Performer.validate!(
              context: @context,
              attribute:,
              value:
            )
          end

          value
        end

        def resolve_internal(name)
          return true if @collection_of_internals.find_by(name:)

          name.to_s.end_with?("?") &&
            @context.config.predicate_methods_enabled &&
            @collection_of_internals.find_by(name: name.to_s.chomp("?").to_sym)
        end

        def raise_error_for(type, name)
          message_text = @context.send(:servactory_service_info).translate(
            "internals.undefined.for_#{type}",
            internal_name: name
          )

          @context.fail_internal!(name, message: message_text)
        end
      end
    end
  end
end
