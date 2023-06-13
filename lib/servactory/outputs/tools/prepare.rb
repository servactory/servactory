# frozen_string_literal: true

module Servactory
  module Outputs
    module Tools
      class Prepare
        def self.prepare(...)
          new(...).prepare
        end

        def initialize(context, collection_of_outputs)
          @context = context
          @collection_of_outputs = collection_of_outputs
        end

        def prepare
          @collection_of_outputs.each do |output|
            create_instance_variable_for(output)
          end
        end

        private

        def create_instance_variable_for(output)
          @context.class.class_eval(context_output_template_for(output))
        end

        # EXAMPLE:
        #
        #   define_method(:user=) do |value|
        #     Servactory::Internals::Validations::Type.validate!( context: self, output:, value: )
        #
        #     instance_variable_set(:@user, value)
        #   end
        #
        def context_output_template_for(output)
          <<-RUBY
            define_method(:#{output.name}=) do |value|
              Servactory::Outputs::Validations::Type.validate!(
                context: self,
                output: output,
                value: value
              )

              instance_variable_set(:@#{output.name}, value)
            end

            attr_reader :#{output.name}
          RUBY
        end
      end
    end
  end
end
