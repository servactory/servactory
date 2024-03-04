# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Inclusion < Base
          def self.check(context:, attribute:, value:, check_key:, **)
            return unless should_be_checked_for?(attribute, value, check_key)

            new(context: context, attribute: attribute, value: value).check
          end

          # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          def self.should_be_checked_for?(attribute, value, check_key)
            check_key == :inclusion && (
              (
                attribute.input? && (
                  attribute.required? || (
                    attribute.optional? && !attribute.default.nil?
                  ) || (
                    attribute.optional? && !value.nil?
                  )
                )
              ) || attribute.internal? || attribute.output?
            )
          end
          # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

          ##########################################################################

          def initialize(context:, attribute:, value:)
            super()

            @context = context
            @attribute = attribute
            @value = value
          end

          def check
            inclusion_in, message = @attribute.inclusion.values_at(:in, :message)

            return if inclusion_in.nil?
            return if inclusion_in.include?(@value)

            add_error_with(message)
          end

          private

          def add_error_with(message)
            add_error(
              message: message.presence || Servactory::Maintenance::Attributes::Translator::Inclusion.default_message,
              service_class_name: @context.class.name,
              "#{@attribute.system_name}": @attribute,
              value: @value
            )
          end
        end
      end
    end
  end
end
