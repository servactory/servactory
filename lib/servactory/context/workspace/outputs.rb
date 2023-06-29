# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Outputs
        def initialize(context:, collection_of_outputs:)
          @context = context
          @collection_of_outputs = collection_of_outputs
        end

        def method_missing(name, *args, &block)
          if name.to_s.end_with?("=")
            setter_with(name: name, value: args.pop) { super }
          else
            getter_with(name: name) { super }
          end
        end

        def respond_to_missing?(name, *)
          @collection_of_outputs.names.include?(name) || super
        end

        private

        def setter_with(name:, value:, &block) # rubocop:disable Lint/UnusedMethodArgument
          prepared_name = name.to_s.delete("=").to_sym

          return yield unless @collection_of_outputs.names.include?(prepared_name)

          output = @collection_of_outputs.find_by(name: prepared_name) # ::Servactory::Outputs::Output

          return yield if output.nil?

          Servactory::Outputs::Validations::Type.validate!(
            context: @context,
            output: output,
            value: value
          )

          @context.send(:assign_output, output.name, value)
        end

        def getter_with(name:, &block) # rubocop:disable Lint/UnusedMethodArgument
          output_name = name.to_s.chomp("?").to_sym
          output = @collection_of_outputs.find_by(name: output_name)

          return yield if output.nil?

          output_value = @context.send(:fetch_output, output.name)

          if name.to_s.end_with?("?")
            Servactory::Utils.query_attribute(output_value)
          else
            output_value
          end
        end
      end
    end
  end
end
