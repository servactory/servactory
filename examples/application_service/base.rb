# frozen_string_literal: true

require_relative "extensions/status_active/dsl"
require_relative "extensions/authorization/dsl"
require_relative "extensions/post_condition/dsl"
require_relative "extensions/transactional/dsl"
require_relative "extensions/rollbackable/dsl"
require_relative "extensions/publishable/dsl"
require_relative "extensions/idempotent/dsl"
require_relative "extensions/api_action/dsl"
require_relative "extensions/external_api_request/dsl"

module ApplicationService
  class Base # rubocop:disable Metrics/ClassLength
    # All extensions are included via with_extensions
    # Extensions can use before/after super pattern:
    # - Before super: Authorization, StatusActive, Idempotent (early exit)
    # - After super: PostCondition, Publishable (outputs available)
    # - Around super: Transactional, Rollbackable (wrap with rescue)
    # - ClassMethods only: ApiAction (generates make calls)
    include Servactory::DSL.with_extensions(
      ApplicationService::Extensions::StatusActive::DSL,
      ApplicationService::Extensions::Authorization::DSL,
      ApplicationService::Extensions::PostCondition::DSL,
      ApplicationService::Extensions::Transactional::DSL,
      ApplicationService::Extensions::Rollbackable::DSL,
      ApplicationService::Extensions::Publishable::DSL,
      ApplicationService::Extensions::Idempotent::DSL,
      ApplicationService::Extensions::ApiAction::DSL,
      ApplicationService::Extensions::ExternalApiRequest::DSL
    )

    FailOnLikeAnActiveRecordException = Class.new(ArgumentError)

    fail_on! FailOnLikeAnActiveRecordException

    configuration do # rubocop:disable Metrics/BlockLength
      input_exception_class ApplicationService::Exceptions::Input
      internal_exception_class ApplicationService::Exceptions::Internal
      output_exception_class ApplicationService::Exceptions::Output

      failure_class ApplicationService::Exceptions::Failure

      result_class ApplicationService::Result

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
          Servactory::ToolKit::DynamicOptions::Format.use,
          Servactory::ToolKit::DynamicOptions::Min.use,
          Servactory::ToolKit::DynamicOptions::Max.use,
          Servactory::ToolKit::DynamicOptions::MultipleOf.use,
          Servactory::ToolKit::DynamicOptions::Target.use,
          ApplicationService::DynamicOptions::CustomEq.use
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
          Servactory::ToolKit::DynamicOptions::Format.use(:check_format),
          Servactory::ToolKit::DynamicOptions::Min.use(:minimum), # Examples of
          Servactory::ToolKit::DynamicOptions::Max.use(:maximum), # custom names
          Servactory::ToolKit::DynamicOptions::MultipleOf.use(:divisible_by),
          Servactory::ToolKit::DynamicOptions::Target.use(:expect),
          ApplicationService::DynamicOptions::CustomEq.use(:best_custom_eq)
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
          Servactory::ToolKit::DynamicOptions::Format.use(
            formats: {
              email: {
                pattern: /@/,
                validator: ->(value:) { value.present? }
              }
            }
          ),
          Servactory::ToolKit::DynamicOptions::Min.use,
          Servactory::ToolKit::DynamicOptions::Max.use,
          Servactory::ToolKit::DynamicOptions::MultipleOf.use,
          Servactory::ToolKit::DynamicOptions::Target.use,
          ApplicationService::DynamicOptions::CustomEq.use
        ]
      )

      action_shortcuts(
        %i[assign],
        {
          restrict: {
            prefix: :create,
            suffix: :restriction
          }
        }
      )

      action_aliases %i[play do_it!]

      i18n_root_key :servactory

      predicate_methods_enabled true
    end
  end
end
