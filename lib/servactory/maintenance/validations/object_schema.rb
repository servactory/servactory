# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class ObjectSchema
        RESERVED_ATTRIBUTES = %i[type required default].freeze
        private_constant :RESERVED_ATTRIBUTES

        attr_reader :errors

        def self.validate!(...)
          new(...).validate!
        end

        def initialize(object:, schema:)
          @object = object
          @schema = schema

          @valid = false
          @errors = []
        end

        def validate!
          @valid = validate_for(object: @object, schema: @schema)

          self
        end

        def valid?
          @valid
        end

        private

        def validate_for(object:, schema:) # rubocop:disable Metrics/MethodLength
          return false unless object.respond_to?(:fetch)

          schema.all? do |schema_key, schema_value|
            attribute_type = schema_value.fetch(:type, String)

            if attribute_type == Hash
              validate_for(object: object.fetch(schema_key, {}), schema: schema_value.except(*RESERVED_ATTRIBUTES))
            else
              is_success = validate_with(
                object: object,
                schema_key: schema_key,
                schema_value: schema_value,
                attribute_type: attribute_type,
                attribute_required: schema_value.fetch(:required, true)
              )

              unless is_success
                @errors.push(
                  {
                    name: schema_key,
                    expected_type: attribute_type,
                    given_type: object.fetch(schema_key, {}).class
                  }
                )
              end

              is_success
            end
          end
        end

        def validate_with(object:, schema_key:, schema_value:, attribute_type:, attribute_required:)
          unless should_be_checked_for?(object: object, schema_key: schema_key, schema_value: schema_value, required: attribute_required)
            return true
          end

          value = object.fetch(schema_key, nil)
          prepared_value = prepare_value_from(schema_value: schema_value, value: value, required: attribute_required)

          Array(attribute_type).any? { |type| prepared_value.is_a?(type) }
        end

        def should_be_checked_for?(object:, schema_key:, schema_value:, required:)
          required || (
            !required && !fetch_default_from(schema_value).nil?
          ) || (
            !required && !object.fetch(schema_key, nil).nil?
          )
        end

        def prepare_value_from(schema_value:, value:, required:)
          if !required && !fetch_default_from(schema_value).nil? && value.blank?
            fetch_default_from(schema_value)
          else
            value
          end
        end

        def fetch_default_from(value)
          value.fetch(:default, nil)
        end
      end
    end
  end
end
