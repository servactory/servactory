# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class Collection
        attr_reader :errors

        def self.validate(...)
          new(...).validate
        end

        def initialize(types:, value:, consists_of:)
          @types = types
          @value = value
          @consists_of = consists_of

          @errors = []
        end

        def validate
          unless @value.is_a?(prepared_type)
            add_error(
              expected_type: prepared_type.name,
              given_type: @value.class.name
            )

            return self
          end

          validate_for!(values: @value)

          self
        end

        def valid?
          @errors.empty?
        end

        private

        def validate_for!(values:) # rubocop:disable Metrics/MethodLength
          values.each do |value|
            value_type = value.class

            if value_type == Array
              validate_for!(values: value)
            else
              is_success = attribute_consists_of_types.include?(value_type)

              next if is_success

              add_error(
                expected_type: attribute_consists_of_types.join(", "),
                given_type: value_type.name
              )
            end
          end
        end

        ########################################################################

        def prepared_type
          @prepared_type ||= @types.fetch(0, Array)
        end

        def attribute_consists_of_types
          @attribute_consists_of_types ||= prepared_types_from(Array(@consists_of.fetch(:type, [])))
        end

        def prepared_types_from(types)
          types.map do |type|
            if type.is_a?(String)
              Object.const_get(type)
            else
              type
            end
          end
        end

        ########################################################################

        def add_error(expected_type:, given_type:)
          @errors << {
            expected_type: expected_type,
            given_type: given_type
          }
        end
      end
    end
  end
end
