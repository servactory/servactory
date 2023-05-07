# frozen_string_literal: true

module Servactory
  module InputArguments
    module Checks
      class Inclusion < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:|
          "[#{service_class_name}] Wrong value in `#{input.name}`, must be one of `#{input.inclusion[:in]}`"
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
          return if @input.inclusion[:in].include?(@value)

          add_error(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input
          )
        end
      end
    end
  end
end
