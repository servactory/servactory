# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Outputs
        def initialize(context, workbench:)
          @context = context
          @collection_of_outputs = workbench.collection
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

          puts
          puts :output_setter_with
          puts output.inspect

          return yield if output.nil?

          Servactory::Outputs::Validations::Type.validate!(
            context: @context,
            output: output,
            value: value
          )

          puts @context.send(:assign_output, output.name, value).inspect
          puts

          @context.send(:assign_output, output.name, value)
        end

        def getter_with(name:, &block) # rubocop:disable Lint/UnusedMethodArgument
          output = @collection_of_outputs.find_by(name: name)

          puts
          puts :output_getter_with
          puts @context.send(:storage)[:outputs].inspect
          puts output.inspect

          return yield if output.nil?

          puts @context.send(:fetch_output, output.name).inspect
          puts

          @context.send(:fetch_output, output.name)
        end
      end
    end
  end
end
