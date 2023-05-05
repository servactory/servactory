# frozen_string_literal: true

module ServiceFactory
  module Context
    class Store
      attr_reader :context

      def initialize(service_class)
        @context = service_class.new

        service_class.class_eval(service_class_template_with(context))
      end

      private

      # EXAMPLE:
      #
      #   attr_reader(:inputs)
      #
      #   def assign_inputs(inputs)
      #     @inputs = inputs
      #   end
      #
      #   def fail_input!(input_attribute_name, message, prefix: true)
      #     message_text = prefix ? "[#{context.class.name}] Custom `\#{input_attribute_name}` input error: " : ""
      #
      #     message_text += message
      #
      #     raise ServiceFactory.configuration.input_argument_error_class, message_text
      #   end
      #
      def service_class_template_with(context)
        <<-RUBY
          attr_reader(:inputs)

          def assign_inputs(inputs)
            @inputs = inputs
          end

          def fail_input!(input_attribute_name, message, prefix: true)
            message_text = prefix ? "[#{context.class.name}] Custom `\#{input_attribute_name}` input error: " : ""

            message_text += message

            raise ServiceFactory.configuration.input_argument_error_class, message_text
          end
        RUBY
      end
    end
  end
end
