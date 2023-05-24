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
          @collection_of_outputs.each do |output_attribute|
            create_instance_variable_for(output_attribute)
          end
        end

        private

        def create_instance_variable_for(output_attribute)
          @context.instance_variable_set(:"@#{output_attribute.name}", nil)

          @context.class.class_eval(context_output_attribute_template_for(output_attribute))
        end

        # EXAMPLE:
        #
        #   define_method(:user=) do |value|
        #     Servactory::Internals::Checks::Type.check!( context: self, output_attribute:, value: )
        #
        #     instance_variable_set(:@user, value)
        #   end
        #
        #   private
        #
        #   attr_reader :user
        #
        def context_output_attribute_template_for(output_attribute)
          <<-RUBY
            define_method(:#{output_attribute.name}=) do |value|
              Servactory::Outputs::Checks::Type.check!(
                context: self,
                output_attribute: output_attribute,
                value: value
              )

              instance_variable_set(:@#{output_attribute.name}, value)
            end

            private

            attr_reader :#{output_attribute.name}
          RUBY
        end
      end
    end
  end
end
