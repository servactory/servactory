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
          @collection_of_inputs.names.include?(name) || super
        end

        private

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Lint/UnusedMethodArgument
        def fetch_with(name:, &block)
          input_name = @context.class.config.predicate_methods_enabled? ? name.to_s.chomp("?").to_sym : name

          input = @collection_of_inputs.find_by(name: input_name)

          return yield if input.nil?

          input_value = @context.send(:servactory_service_warehouse).fetch_input(input.name)

          # if input.optional? && input.default.present? && (
          #   (!input_value.is_a?(TrueClass) && !input_value.is_a?(FalseClass) && input_value.blank?) ||
          #     input_value.nil?
          # ) # do
          #   input_value = input.default
          # end

          if input.optional? && !input.default.nil? && !Servactory::Utils.value_present?(input_value)
            input_value = input.default
          end

          input_prepare = input.prepare.fetch(:in, nil)
          input_value = input_prepare.call(value: input_value) if input_prepare.present?

          if name.to_s.end_with?("?") && @context.class.config.predicate_methods_enabled?
            Servactory::Utils.query_attribute(input_value)
          else
            input_value
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Lint/UnusedMethodArgument

        def raise_error_for(type, name)
          message_text = @context.send(:servactory_service_info).translate(
            "inputs.undefined.for_#{type}",
            input_name: name
          )

          raise @context.class.config.input_exception_class.new(
            context: @context,
            message: message_text,
            input_name: name
          )
        end
      end
    end
  end
end
