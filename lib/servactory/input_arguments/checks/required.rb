# frozen_string_literal: true

module Servactory
  module InputArguments
    module Checks
      class Required < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, value:|
          if input.array? && value.present?
            "[#{service_class_name}] Required element in input array `#{input.name}` is missing"
          else
            "[#{service_class_name}] Required input `#{input.name}` is missing"
          end
        end

        private_constant :DEFAULT_MESSAGE

        def self.check(context:, input:, value:, **)
          return unless should_be_checked_for?(input)

          new(context: context, input: input, value: value).check
        end

        def self.should_be_checked_for?(input)
          input.required?
        end

        ##########################################################################

        def initialize(context:, input:, value:)
          super()

          @context = context
          @input = input
          @value = value
        end

        def check # rubocop:disable Metrics/MethodLength
          if @input.array? && @value.present?
            return if @value.respond_to?(:all?) && @value.all?(&:present?)
          elsif @value.present?
            return
          end

          add_error(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input,
            value: @value
          )
        end
      end
    end
  end
end
