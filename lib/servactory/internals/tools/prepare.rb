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
          @collection_of_internals.each do |internal|
            create_instance_variable_for(internal)
          end
        end

        private

        def create_instance_variable_for(internal)
          @context.instance_variable_set(:"@#{internal.name}", nil)

          @context.class.class_eval(context_internal_template_for(internal))
        end

        # EXAMPLE:
        #
        #   define_method(:user=) do |value|
        #     Servactory::Internals::Checks::Type.check!( context: self, internal:, value: )
        #
        #     instance_variable_set(:@user, value)
        #   end
        #
        #   private attr_reader :user
        #
        def context_internal_template_for(internal)
          <<-RUBY
            define_method(:#{internal.name}=) do |value|
              Servactory::Internals::Checks::Type.check!(
                context: self,
                internal: internal,
                value: value
              )

              instance_variable_set(:@#{internal.name}, value)
            end

            private

            attr_reader :#{internal.name}
          RUBY
        end
      end
    end
  end
end
