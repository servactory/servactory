# frozen_string_literal: true

require_relative "extensions/status_active/dsl"

module ApplicationService
  class Base
    include Servactory::DSL.with_extensions(
      ApplicationService::Extensions::StatusActive::DSL
    )

    configuration do
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
              unless data.is_a?(Hash)
                data = {
                  is: ->(value:) { value >= data },
                  message: lambda do |input:, value:, **|
                    message.call(input_name: input.name, expected_value: data, given_value: value)
                  end
                }
              end

              {
                must: {
                  "be_greater_than_or_equal_to": data
                }
              }
            end
          ),
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :max,
            equivalent: lambda do |data|
              unless data.is_a?(Hash)
                data = {
                  is: ->(value:) {
                    puts
                    puts
                    puts data.inspect
                    puts
                    puts

                    value <= data },
                  message: lambda do |input:, value:, **|
                    message.call(input_name: input.name, expected_value: data, given_value: value)
                  end
                }
              end

              {
                must: {
                  "be_less_than_or_equal_to": data
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

# module ApplicationService
#   class Base < Servactory::Base.with_extensions(
#     ApplicationService::Extensions::StatusActive::DSL
#   ).with_configuration(
#     input_error_class: ApplicationService::Errors::InputError,
#     output_error_class: ApplicationService::Errors::OutputError,
#     internal_error_class: ApplicationService::Errors::InternalError,
#
#     failure_class: ApplicationService::Errors::Failure
#   )
#   end
# end

# module ApplicationService
#   class Base
#     include Servactory::DSL
#       .with_extensions(
#         ApplicationService::Extensions::StatusActive::DSL
#       ).with_configuration do
#         input_error_class ApplicationService::Errors::InputError
#         output_error_class ApplicationService::Errors::OutputError
#         internal_error_class ApplicationService::Errors::InternalError
#
#         failure_class ApplicationService::Errors::Failure
#       end
#   end
# end
