# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class Collection
        attr_reader :errors

        def self.validate(...)
          new(...).validate
        end

        def initialize(attribute:, types:, value:)
          @attribute = attribute
          @types = types
          @value = value

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

          validate_value!

          self
        end

        def valid?
          @errors.empty?
        end

        private

        def validate_value!
          return if unnecessary_types.empty?

          add_error(
            expected_type: attribute_consists_of_types.join(", "),
            given_type: unnecessary_types.join(", ")
          )
        end

        ########################################################################

        def prepared_type
          @prepared_type ||= @types.fetch(0, Array)
        end

        def attribute_consists_of_types
          @attribute_consists_of_types ||= prepared_types_from(Array(@attribute.consists_of.fetch(:type, [])))
        end

        def unnecessary_types
          @unnecessary_types ||= @value&.map(&:class)&.difference(attribute_consists_of_types).presence || []
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
