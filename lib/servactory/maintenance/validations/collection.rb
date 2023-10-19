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

        def validate # rubocop:disable Metrics/MethodLength
          unless @value.is_a?(@types.fetch(0, Array))
            add_error(
              expected_type: @types.fetch(0, Array),
              given_type: @value.class
            )

            return self
          end

          @valid = @value.respond_to?(:all?) && @value.all? do |asd|
            is_success = asd.is_a?(@type)

            unless is_success
              add_error(
                expected_type: @type,
                given_type: asd.class
              )
            end

            is_success
          end

          self
        end

        def valid?
          @errors.empty?
        end

        private

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
