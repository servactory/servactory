# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Internals
        def initialize(context, collection_of_internals:)
          @context = context
          @collection_of_internals = collection_of_internals
        end

        def method_missing(name, *args, &block)
          if name.to_s.end_with?("=")
            prepared_name = name.to_s.delete("=").to_sym

            return super unless @collection_of_internals.names.include?(prepared_name)

            internal = @collection_of_internals.find_by(name: prepared_name)
            value = args.pop

            Servactory::Internals::Validations::Type.validate!(
              context: @context,
              internal: internal,
              value: value
            )

            @context.instance_variable_set(:"@#{internal.name}", value)
          else
            internal = @collection_of_internals.find_by(name: name)

            return super if internal.nil?

            @context.instance_variable_get(:"@#{internal.name}")
          end
        end

        def respond_to_missing?(name, *)
          @collection_of_internals.names.include?(name) || super
        end
      end

      class Outputs
        def initialize(context, collection_of_outputs:)
          @context = context
          @collection_of_outputs = collection_of_outputs
        end

        def method_missing(name, *args, &block)
          if name.to_s.end_with?("=")
            prepared_name = name.to_s.delete("=").to_sym

            return super unless @collection_of_outputs.names.include?(prepared_name)

            output = @collection_of_outputs.find_by(name: prepared_name)
            value = args.pop

            Servactory::Outputs::Validations::Type.validate!(
              context: @context,
              output: output,
              value: value
            )

            @context.instance_variable_set(:"@#{output.name}", value)
          else
            output = @collection_of_outputs.find_by(name: name)

            return super if output.nil?

            @context.instance_variable_get(:"@#{output.name}")
          end
        end

        def respond_to_missing?(name, *)
          @collection_of_outputs.names.include?(name) || super
        end
      end

      def internals
        @internals ||= Internals.new(self, collection_of_internals: self.class.send(:collection_of_internals))
      end

      def outputs
        @outputs ||= Outputs.new(self, collection_of_outputs: self.class.send(:collection_of_outputs))
      end

      def errors
        @errors ||= Servactory::Errors::Collection.new
      end

      def assign_inputs(inputs)
        @inputs = inputs
      end

      def raise_first_fail
        return if (tmp_errors = errors.for_fails.not_blank).empty?

        raise tmp_errors.first
      end

      protected

      attr_reader :inputs

      def fail_input!(input_name, message:)
        raise Servactory.configuration.input_error_class.new(
          input_name: input_name,
          message: message
        )
      end

      def fail!(
        message:,
        failure_class: Servactory.configuration.failure_class,
        meta: nil
      )
        failure = failure_class.new(message: message, meta: meta)

        raise failure if @service_strict_mode

        errors << failure
      end

      private

      def assign_service_strict_mode(flag)
        @service_strict_mode = flag
      end
    end
  end
end
