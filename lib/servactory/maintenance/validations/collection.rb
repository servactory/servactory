# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class Collection
        attr_reader :errors

        def self.validate(...)
          new(...).validate
        end

        def initialize(value:, types:, type:)
          @value = value
          @types = types
          @type = type

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

        def prepared_type
          @prepared_type ||= @types.fetch(0, Array)
        end

        def validate_value!
          @value.each do |value_item|
            next if value_item.is_a?(@type)

            add_error(
              expected_type: @type,
              given_type: value_item.class.name
            )
          end
        end

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
