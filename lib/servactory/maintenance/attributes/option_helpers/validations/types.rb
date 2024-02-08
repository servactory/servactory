module Servactory
  module Maintenance
    module Attributes
      module OptionHelpers
        module Validations
          module Types
            extend self

            def apply
              Servactory::Maintenance::Attributes::OptionHelper.new(
                name: :type,
                equivalent: lambda do |type|
                  types = Array(type)

                  {
                    must: {
                      be_type: {
                        is: lambda do |input:, value:, **|
                          prepared_types_for(input:, types:).any? do |type|
                            value.is_a?(type)
                          end
                        end,
                        message: lambda do |input:, value:, **|
                          I18n.t(
                            "servactory.#{input.i18n_name}.validations.type.default_error.default",
                            service_class_name: service_class_name,
                            "#{attribute.system_name}_name": input.name,
                            expected_type: prepared_types.join(", "),
                            given_type: given_type
                          )
                        end
                      }
                    }
                  }
                end
              )
            end

            private

            def prepared_types_for(input:, types:)
              # @prepared_types ||=
              #   if input.collection_mode?
              #     prepared_types_from(Array(input.consists_of.fetch(:type, [])))
              #   else
              #     prepared_types_from(types)
              #   end

              @prepared_types_for ||= prepared_types_from(types)
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
          end
        end
      end
    end
  end
end
