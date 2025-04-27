# frozen_string_literal: true

require "zeitwerk"
require "forwardable"
require "servactory"
require "servactory/test_kit/rspec/helpers"
require "servactory/test_kit/rspec/matchers"

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path("../examples", __dir__))
loader.setup

Dir[File.join(__dir__, "support", "**", "*.rb")].each { |file| require file }

I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect

    # Configures the maximum character length that RSpec will print while
    # formatting an object. You can set length to nil to prevent RSpec from
    # doing truncation.
    c.max_formatted_output_length = nil
  end

  config.include Servactory::TestKit::Rspec::Helpers, type: :service
  config.include Servactory::TestKit::Rspec::Matchers, type: :service
end

Servactory.configure(:application) do |config|
  config.input_exception_class = ApplicationService::Exceptions::Input
  config.internal_exception_class = ApplicationService::Exceptions::Internal
  config.output_exception_class = ApplicationService::Exceptions::Output

  config.failure_class = ApplicationService::Exceptions::Failure

  config.result_class = ApplicationService::Result

  config.input_option_helpers = [
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
    ApplicationService::DynamicOptions::CustomEq.use
  ]

  config.internal_option_helpers = [
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
    ApplicationService::DynamicOptions::CustomEq.use(:best_custom_eq)
  ]

  config.output_option_helpers = [
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
    ApplicationService::DynamicOptions::CustomEq.use
  ]

  config.action_shortcuts = {
    assign: {
      prefix: :assign,
      suffix: nil
    },
    restrict: {
      prefix: :create,
      suffix: :restriction
    }
  }

  config.action_aliases = %i[play do_it!]

  config.i18n_root_key = :servactory

  config.predicate_methods_enabled = true
end
