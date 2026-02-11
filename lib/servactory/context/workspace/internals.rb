# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Internals
        def initialize(context:, collection_of_internals:)
          @context = context
          @collection_of_internals = collection_of_internals
          @validated_attributes = Set.new

          define_attribute_methods!
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
          @collection_of_internals.each do |internal|
            define_singleton_method(internal.name) do
              fetch_value(attribute: internal)
            end

            define_singleton_method(:"#{internal.name}=") do |value|
              assign_value(attribute: internal, value:)
            end

            next unless @context.config.predicate_methods_enabled

            define_singleton_method(:"#{internal.name}?") do
              fetch_predicate(attribute: internal)
            end
          end
        end

        def assign_value(attribute:, value:)
          @validated_attributes.delete(attribute.name)

          Servactory::Maintenance::Validations::Performer.validate!(
            context: @context,
            attribute:,
            value:
          )

          @context.send(:servactory_service_warehouse).assign_internal(attribute.name, value)

          @validated_attributes << attribute.name
        end

        def fetch_value(attribute:)
          value = @context.send(:servactory_service_warehouse).fetch_internal(attribute.name)

          if @validated_attributes.exclude?(attribute.name)
            Servactory::Maintenance::Validations::Performer.validate!(
              context: @context,
              attribute:,
              value:
            )
          end

          value
        end

        def fetch_predicate(attribute:)
          Servactory::Utils.query_attribute(fetch_value(attribute:))
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
