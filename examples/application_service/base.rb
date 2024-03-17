# frozen_string_literal: true

require_relative "extensions/status_active/dsl"

module ApplicationService
  class Base
    include Servactory::DSL.with_extensions(
      ApplicationService::Extensions::StatusActive::DSL
    )

    configuration do # rubocop:disable Metrics/BlockLength
      input_exception_class ApplicationService::Exceptions::Input
      internal_exception_class ApplicationService::Exceptions::Internal
      output_exception_class ApplicationService::Exceptions::Output

      # DEPRECATED: These configs will be deleted after release 2.4.
      # input_error_class ApplicationService::Errors::InputError
      # internal_error_class ApplicationService::Errors::InternalError
      # output_error_class ApplicationService::Errors::OutputError

      failure_class ApplicationService::Exceptions::Failure

      input_option_helpers(
        [
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: lambda do |value:, **|
                    value.all? do |id|
                      return true if id.blank? # NOTE: This is not the responsibility of this `must` validator

                      (id.is_a?(Integer) ? id.abs.digits.length : id.size) == 6
                    end
                  end,
                  message: lambda do |input:, **|
                    "Wrong IDs in `#{input.name}`"
                  end
                }
              }
            }
          ),
          Servactory::ToolKit::DynamicOptions::Format.setup,
          Servactory::ToolKit::DynamicOptions::Min.setup,
          Servactory::ToolKit::DynamicOptions::Max.setup,
          ApplicationService::DynamicOptions::CustomEq.setup
        ]
      )

      internal_option_helpers(
        [
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: lambda do |value:, **|
                    value.all? do |id|
                      return true if id.blank? # NOTE: This is not the responsibility of this `must` validator

                      (id.is_a?(Integer) ? id.abs.digits.length : id.size) == 6
                    end
                  end,
                  message: lambda do |internal:, **|
                    "Wrong IDs in `#{internal.name}`"
                  end
                }
              }
            }
          ),
          Servactory::ToolKit::DynamicOptions::Format.setup(:check_format),
          Servactory::ToolKit::DynamicOptions::Min.setup(:minimum), # Examples of
          Servactory::ToolKit::DynamicOptions::Max.setup(:maximum), # custom names
          ApplicationService::DynamicOptions::CustomEq.setup(:best_custom_eq)
        ]
      )

      output_option_helpers(
        [
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: lambda do |value:, **|
                    value.all? do |id|
                      return true if id.blank? # NOTE: This is not the responsibility of this `must` validator

                      (id.is_a?(Integer) ? id.abs.digits.length : id.size) == 6
                    end
                  end,
                  message: lambda do |output:, **|
                    "Wrong IDs in `#{output.name}`"
                  end
                }
              }
            }
          ),
          Servactory::ToolKit::DynamicOptions::Format.setup,
          Servactory::ToolKit::DynamicOptions::Min.setup,
          Servactory::ToolKit::DynamicOptions::Max.setup,
          ApplicationService::DynamicOptions::CustomEq.setup
        ]
      )

      action_shortcuts %i[assign]
      action_aliases %i[play do_it!]
    end
  end
end
