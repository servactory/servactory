# frozen_string_literal: true

module Servactory
  module InputAttributes
    module Checks
      class Inclusion < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, value:|
          I18n.t(
            "servactory.input_attributes.checks.inclusion.default_error",
            service_class_name: service_class_name,
            input_name: input.name,
            input_inclusion: input.inclusion[:in],
            value: value
          )
        end

        private_constant :DEFAULT_MESSAGE

        def self.check(context:, input:, value:, check_key:, **)
          return unless should_be_checked_for?(input, check_key)

          new(context: context, input: input, value: value).check
        end

        def self.should_be_checked_for?(input, check_key)
          check_key == :inclusion && input.inclusion_present?
        end

        ##########################################################################

        def initialize(context:, input:, value:)
          super()

          @context = context
          @input = input
          @value = value
        end

        def check
          inclusion_in, message = @input.inclusion.values_at(:in, :message)

          return if inclusion_in.nil?
          return if inclusion_in.include?(@value)

          add_error(
            message.presence || DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input,
            value: @value
          )
        end
      end
    end
  end
end
