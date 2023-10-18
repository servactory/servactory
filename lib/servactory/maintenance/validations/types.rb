# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class Types
        def self.prepare!(...)
          new(...).prepare!
        end

        def self.validate!(
          attribute:,
          types:,
          value:,
          default_collection_error:,
          default_object_error:,
          default_error:
        )
          new(
            attribute: attribute,
            types: types
          ).validate!(
            value: value,
            default_collection_error: default_collection_error,
            default_object_error: default_object_error,
            default_error: default_error
          )
        end

        def initialize(attribute:, types:)
          @attribute = attribute
          @types = types
        end

        def prepare!
          if @attribute.collection_mode?
            prepared_types_from(Array(@attribute.consists_of.fetch(:type, [])))
          else
            prepared_types_from(@types)
          end
        end

        def validate!(value:, default_collection_error:, default_object_error:, default_error:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          collection_validator = nil
          object_schema_validator = nil

          return if @types.any? do |type|
            if @attribute.collection_mode?
              collection_validator = Servactory::Maintenance::Validations::Collection.validate(
                value: value,
                types: @attribute.types,
                type: type
              )

              collection_validator.valid?
            elsif @attribute.hash_mode?
              object_schema_validator = Servactory::Maintenance::Validations::ObjectSchema.validate(
                object: value,
                schema: @attribute.schema
              )

              object_schema_validator.valid?
            else
              value.is_a?(type)
            end
          end

          if (first_error = collection_validator&.errors&.first).present?
            return default_collection_error.call(first_error)
          end

          if (first_error = object_schema_validator&.errors&.first).present?
            return default_object_error.call(first_error)
          end

          default_error.call
        end

        private

        def prepared_types_from(types)
          types.map do |type|
            if type.is_a?(String)
              Object.const_get(type)
            else
              type
            end
          end
        end
      end
    end
  end
end
