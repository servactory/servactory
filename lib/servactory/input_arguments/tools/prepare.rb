# frozen_string_literal: true

module Servactory
  module InputArguments
    module Tools
      class Prepare
        def self.prepare(...)
          new(...).prepare
        end

        def initialize(context, incoming_arguments, collection_of_input_arguments)
          @context = context
          @incoming_arguments = incoming_arguments
          @collection_of_input_arguments = collection_of_input_arguments
        end

        def prepare
          @inputs_variables = {}
          @internal_variables = {}

          @collection_of_input_arguments.each do |input|
            process_input(input)
          end

          create_instance_variables
        end

        private

        def process_input(input)
          input_value = @incoming_arguments.fetch(input.name, nil)
          input_value = input.default if input.optional? && input_value.blank?

          @inputs_variables[input.name] = input_value

          return unless input.internal?

          @internal_variables[input.name] = input_value
        end

        def create_instance_variables
          inputs_class = Servactory::Inputs.dup
          inputs_class.class_eval(class_inputs_template) if class_inputs_template.present?

          @context.assign_inputs(inputs_class.new(**@inputs_variables))

          @context.class.class_eval(context_internal_variables_template) if context_internal_variables_template.present?

          @internal_variables.each do |input_name, input_value|
            @context.instance_variable_set(:"@#{input_name}", input_value)
          end
        end

        ########################################################################

        # EXAMPLE:
        #
        #   attr_reader(*[:attr_1, :attr_2, :attr_3])
        #
        #   def initialize(attr_1:, attr_2:, attr_3:)
        #     @attr_1 = attr_1; @attr_2 = attr_2; @attr_3 = attr_3;
        #   end
        #
        def class_inputs_template
          return if @inputs_variables.blank?

          @class_inputs_template ||= <<-RUBY
            attr_reader(*#{@inputs_variables.keys})

            def initialize(#{@inputs_variables.keys.join(':, ')}:)
              #{@inputs_variables.keys.map { |key| "@#{key} = #{key}" }.join('; ')}
            end
          RUBY
        end

        # EXAMPLE:
        #
        #   private
        #
        #   attr_reader(*[:attr_1])
        #
        def context_internal_variables_template
          return if @internal_variables.blank?

          @context_internal_variables_template ||= <<-RUBY
            private

            attr_reader(*#{@internal_variables.keys})
          RUBY
        end
      end
    end
  end
end
