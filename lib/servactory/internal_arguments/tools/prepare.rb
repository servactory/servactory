# frozen_string_literal: true

module Servactory
  module InternalArguments
    module Tools
      class Prepare
        def self.prepare(...)
          new(...).prepare
        end

        def initialize(context, collection_of_internal_arguments)
          @context = context
          @collection_of_internal_arguments = collection_of_internal_arguments
        end

        def prepare
          @collection_of_internal_arguments.each do |internal_argument|
            create_instance_variable_for(internal_argument)
          end
        end

        private

        def create_instance_variable_for(internal_argument)
          @context.instance_variable_set(:"@#{internal_argument.name}", nil)

          @context.class.class_eval(context_internal_argument_template_for(internal_argument))
        end

        # EXAMPLE:
        #
        #   define_method(:user=) do |value|
        #     Servactory::InternalArguments::Checks::Type.check!( context: self, internal_argument:, value: )
        #
        #     instance_variable_set(:@user, value)
        #   end
        #
        #   private attr_reader :user
        #
        def context_internal_argument_template_for(internal_argument)
          <<-RUBY
            define_method(:#{internal_argument.name}=) do |value|
              Servactory::InternalArguments::Checks::Type.check!(
                context: self,
                internal_argument: internal_argument,
                value: value
              )

              instance_variable_set(:@#{internal_argument.name}, value)
            end

            private

            attr_reader :#{internal_argument.name}
          RUBY
        end
      end
    end
  end
end
