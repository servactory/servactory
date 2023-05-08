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
      #     @errors << Servactory::Errors::Error.new(:_fail, error)
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

          def fail_input!(input_attribute_name, message)
            raise Servactory.configuration.input_argument_error_class,
                  Servactory::Errors::Error.new(input_attribute_name, message).message
          end

          def fail!(error)
            @errors << Servactory::Errors::Error.new(:_fail, error)
          end

          def raise_first_error
            return if (tmp_errors = errors.reject(&:blank?).uniq).empty?

            raise Servactory.configuration.failure_class, tmp_errors.first.message
          end
        RUBY
      end
    end
  end
end
