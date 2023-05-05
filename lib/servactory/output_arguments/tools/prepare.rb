# frozen_string_literal: true

module Servactory
  module OutputArguments
    module Tools
      class Prepare
        def self.prepare(...)
          new(...).prepare
        end

        def initialize(context, collection_of_output_arguments)
          @context = context
          @collection_of_output_arguments = collection_of_output_arguments
        end

        def prepare
          @collection_of_output_arguments.each do |output_argument|
            create_instance_variable_for(output_argument)
          end
        end

        private

        def create_instance_variable_for(output_argument)
          @context.instance_variable_set(:"@#{output_argument.name}", nil)

          @context.class.class_eval(context_output_argument_template_for(output_argument))
        end

        # EXAMPLE:
        #
        #   define_method(:user=) do |value|;
        #     Servactory::InternalArguments::Checks::Type.check!( context: self, output_argument:, value: );
        #
        #     instance_variable_set(:@user, value);
        #   end;
        #
        #   private;
        #
        #   attr_reader :user;
        #
        def context_output_argument_template_for(output_argument)
          <<-RUBY.squish
            define_method(:#{output_argument.name}=) do |value|;
              Servactory::OutputArguments::Checks::Type.check!(
                context: self,
                output_argument: output_argument,
                value: value
              );

              instance_variable_set(:@#{output_argument.name}, value);
            end;

            private;

            attr_reader :#{output_argument.name};
          RUBY
        end
      end
    end
  end
end
