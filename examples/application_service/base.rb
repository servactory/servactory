# frozen_string_literal: true

require_relative "extensions/status_active/dsl"

module ApplicationService
  class Base
    include Servactory::DSL.with_extensions(
      ApplicationService::Extensions::StatusActive::DSL
    )

    configuration do # rubocop:disable Metrics/BlockLength
      input_error_class ApplicationService::Errors::InputError
      output_error_class ApplicationService::Errors::OutputError
      internal_error_class ApplicationService::Errors::InternalError

      failure_class ApplicationService::Errors::Failure

      input_option_helpers(
        [
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: ->(value:) { value.all? { |id| id.size == 6 } },
                  message: lambda do |input:, **|
                    "Wrong IDs in `#{input.name}`"
                  end
                }
              }
            }
          ),
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :min,
            equivalent: lambda do |data|
              received_value = (data.is_a?(Hash) && data.key?(:is) ? data[:is] : data)

              {
                must: {
                  be_greater_than_or_equal_to: {
                    is: ->(value:) { value >= received_value },
                    message: lambda do |service_class_name:, input:, value:, **|
                      "[#{service_class_name}] #{input.system_name.to_s.titleize} attribute `#{input.name}` " \
                        "received value `#{value}`, which is less than `#{received_value}`"
                    end
                  }
                }
              }
            end
          ),
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :max,
            equivalent: lambda do |data|
              new_data =
                if data.is_a?(Hash)
                  data[:is] = ->(**) { data[:is] } unless data[:is].is_a?(Proc)
                  data
                else
                  {
                    is: ->(value:) { value <= data },
                    message: lambda do |service_class_name:, input:, value:, **|
                      "[#{service_class_name}] #{input.system_name.to_s.titleize} attribute `#{input.name}` " \
                        "received value `#{value}`, which is less than `#{data}`"
                    end
                  }
                end

              {
                must: {
                  be_less_than_or_equal_to: new_data
                }
              }
            end
          )
        ]
      )

      action_shortcuts %i[assign]
      action_aliases %i[play do_it!]
    end
  end
end
