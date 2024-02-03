# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Inputs
        RESERVED_ATTRIBUTES = %i[type required default].freeze
        private_constant :RESERVED_ATTRIBUTES

        def initialize(context:, incoming_arguments:, collection_of_inputs:)
          @context = context
          @incoming_arguments = incoming_arguments
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

            raise_error_for(:setter, prepared_name)
          else
            getter_with(name: name) { raise_error_for(:getter, name) }
          end
        end

        def respond_to_missing?(name, *)
          @collection_of_inputs.names.include?(name) || super
        end

        private

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize,  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Lint/UnusedMethodArgument
        def getter_with(name:, &block)
          input_name = name.to_s.chomp("?").to_sym
          input = @collection_of_inputs.find_by(name: input_name)

          return yield if input.nil?

          input_value = @incoming_arguments.fetch(input.name, nil)
          input_value = input.default if input.optional? && input_value.blank?

          if input.hash_mode? && (tmp_schema = input.schema.fetch(:is)).present?
            input_value = prepare_hash_values_inside(object: input_value, schema: tmp_schema)
          end

          input_prepare = input.prepare.fetch(:in, nil)
          input_value = input_prepare.call(value: input_value) if input_prepare.present?

          if name.to_s.end_with?("?")
            Servactory::Utils.query_attribute(input_value)
          else
            input_value
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize,  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Lint/UnusedMethodArgument

        def prepare_hash_values_inside(object:, schema:) # rubocop:disable Metrics/MethodLength
          return object unless object.respond_to?(:fetch)

          schema.to_h do |schema_key, schema_value|
            attribute_type = schema_value.fetch(:type, String)

            result =
              if attribute_type == Hash
                prepare_hash_values_inside(
                  object: object.fetch(schema_key, {}),
                  schema: schema_value.except(*RESERVED_ATTRIBUTES)
                )
              else
                fetch_hash_values_from(
                  value: object.fetch(schema_key, {}),
                  schema_value: schema_value,
                  attribute_required: schema_value.fetch(:required, true)
                )
              end

            [schema_key, result]
          end
        end

        def fetch_hash_values_from(value:, schema_value:, attribute_required:)
          return value if attribute_required
          return value if value.present?

          schema_value.fetch(:default, nil)
        end

        def raise_error_for(type, name)
          message_text = I18n.t(
            "servactory.inputs.undefined.#{type}",
            service_class_name: @context.class.name,
            input_name: name
          )

          raise @context.class.config.input_error_class.new(message: message_text, input_name: name)
        end
      end
    end
  end
end
