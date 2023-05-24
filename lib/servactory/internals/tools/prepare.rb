# frozen_string_literal: true

module Servactory
  module Internals
    module Tools
      class Prepare
        def self.prepare(...)
          new(...).prepare
        end

        def initialize(context, collection_of_internals)
          @context = context
          @collection_of_internals = collection_of_internals
        end

        def prepare
          @collection_of_internals.each do |internal_attribute|
            create_instance_variable_for(internal_attribute)
          end
        end

        private

        def create_instance_variable_for(internal_attribute)
          @context.instance_variable_set(:"@#{internal_attribute.name}", nil)

          @context.class.class_eval(context_internal_attribute_template_for(internal_attribute))
        end

        # EXAMPLE:
        #
        #   define_method(:user=) do |value|
        #     Servactory::Internals::Checks::Type.check!( context: self, internal_attribute:, value: )
        #
        #     instance_variable_set(:@user, value)
        #   end
        #
        #   private attr_reader :user
        #
        def context_internal_attribute_template_for(internal_attribute)
          <<-RUBY
            define_method(:#{internal_attribute.name}=) do |value|
              Servactory::Internals::Checks::Type.check!(
                context: self,
                internal_attribute: internal_attribute,
                value: value
              )

              instance_variable_set(:@#{internal_attribute.name}, value)
            end

            private

            attr_reader :#{internal_attribute.name}
          RUBY
        end
      end
    end
  end
end
