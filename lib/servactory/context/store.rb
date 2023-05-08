# frozen_string_literal: true

module Servactory
  module Context
    class Store
      attr_reader :context

      def initialize(service_class)
        service_class.class_eval(service_class_template)

        @context = service_class.new
      end

      private

      # EXAMPLE:
      #
      #   attr_reader(:inputs, :errors)
      #
      #   def initialize
      #     @errors = []
      #   end
      #
      #   def assign_inputs(inputs)
      #     @inputs = inputs
      #   end
      #
      #   def fail_input!(_input_attribute_name, message)
      #     raise Servactory.configuration.input_argument_error_class, message
      #   end
      #
      #   def fail!(error)
      #     @errors << error
      #   end
      #
      def service_class_template
        <<-RUBY
          attr_reader(:inputs, :errors)

          def initialize
            @errors = []
          end

          def assign_inputs(inputs)
            @inputs = inputs
          end

          def fail_input!(_input_attribute_name, message)
            raise Servactory.configuration.input_argument_error_class, message
          end

          def fail!(error)
            @errors << error
          end

          def raise_first_error
            return if (tmp_errors = errors.reject(&:blank?).uniq).empty?

            raise Servactory.configuration.failure_class, tmp_errors.first
          end
        RUBY
      end
    end
  end
end
