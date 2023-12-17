# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Type < Base
          def self.check(context:, attribute:, value:, check_key:, **)
            return unless should_be_checked_for?(attribute, value, check_key)

            new(context: context, attribute: attribute, value: value).check
          end

          def self.should_be_checked_for?(attribute, value, check_key) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
            check_key == :types && (
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

          def initialize(context:, attribute:, value:)
            super()

            @context = context
            @attribute = attribute
            @value = value
          end

          def check
            Servactory::Maintenance::Validations::Types.validate!(
              context: @context,
              attribute: @attribute,
              types: @attribute.types,
              value: prepared_value,
              error_callback: ->(**args) { add_error(**args) }
            )
          end

          private

          def prepared_value
            @prepared_value ||= if @attribute.input? && @attribute.optional? && !@attribute.default.nil? && @value.blank?
                                  @attribute.default
                                else
                                  @value
                                end
          end
        end
      end
    end
  end
end
