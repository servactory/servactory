# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Inputs
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

        def getter_with(name:, &block) # rubocop:disable Metrics/MethodLength, Lint/UnusedMethodArgument, Metrics/AbcSize
          input_name = name.to_s.chomp("?").to_sym
          input = @collection_of_inputs.find_by(name: input_name)

          return yield if input.nil?

          input_value = @incoming_arguments.fetch(input.name, nil)
          input_value = input.default if input.optional? && input_value.blank?

          input_prepare = input.prepare.fetch(:in, nil)
          input_value = input_prepare.call(value: input_value) if input_prepare.present?

          if name.to_s.end_with?("?")
            Servactory::Utils.query_attribute(input_value)
          else
            input_value
          end
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
