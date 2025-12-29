# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Input
            # Submatcher for integration testing of input validation.
            #
            # ## Purpose
            #
            # Performs integration testing of input attributes by calling the
            # actual service and verifying validation behavior. Tests type checks,
            # required/optional status, inclusion, and target validations.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:status).valid_with(valid_attributes) }
            # it { is_expected.to have_service_input(:count).valid_with(false) }
            # ```
            #
            # ## Deprecation Notice
            #
            # This submatcher is planned to be decommissioned. Consider using
            # direct service call tests instead.
            #
            # ## Validation Steps
            #
            # 1. `success_passes?` - service succeeds with valid attributes
            # 2. `failure_type_passes?` - fails correctly with wrong type
            # 3. `failure_required_passes?` - fails when required input is nil
            # 4. `failure_optional_passes?` - succeeds when optional input is nil
            # 5. `failure_inclusion_passes?` - fails with value outside inclusion
            # 6. `failure_target_passes?` - fails with value outside target
            class ValidWithSubmatcher < Base::Submatcher # rubocop:disable Metrics/ClassLength
              # Creates a new valid_with submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param attributes [Hash, FalseClass] Test attributes or false to skip
              # @return [ValidWithSubmatcher] New submatcher instance
              def initialize(context, attributes)
                super(context)
                @attributes = attributes.is_a?(FalseClass) ? attributes : Servactory::Utils.adapt(attributes)
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description
              def description
                "valid_with attribute checking"
              end

              protected

              # Runs all validation checks in sequence.
              #
              # @return [Boolean] True if all validation scenarios pass
              def passes?
                return true if attributes.is_a?(FalseClass)

                success_passes? &&
                  failure_type_passes? &&
                  failure_required_passes? &&
                  failure_optional_passes? &&
                  failure_inclusion_passes? &&
                  failure_target_passes?
              end

              # Builds the failure message for valid_with validation.
              #
              # @return [String] Generic failure message
              def build_failure_message
                "should work as expected on the specified attributes based on its options"
              end

              private

              attr_reader :attributes

              # Checks that service succeeds with valid attributes.
              #
              # @return [Boolean] True if service call succeeds
              def success_passes?
                described_class.call!(attributes).success?
              rescue Servactory::Exceptions::Input
                false
              rescue StandardError
                true
              end

              # Checks that service fails with wrong type.
              #
              # @return [Boolean] True if type validation fails as expected
              def failure_type_passes? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
                option_types = attribute_data.fetch(:types)

                prepared_attributes = attributes.dup
                prepared_attributes[attribute_name] = Servactory::TestKit::FakeType.new

                input_required_message = I18n.t(
                  "#{i18n_root_key}.inputs.validations.type.default_error.default",
                  service_class_name: described_class.name,
                  input_name: attribute_name,
                  expected_type: option_types.join(", "),
                  given_type: Servactory::TestKit::FakeType.new.class.name
                )

                expect_failure_with!(prepared_attributes, input_required_message)
              end

              # Checks that required validation fails when input is nil.
              #
              # @return [Boolean] True if required validation fails as expected
              def failure_required_passes? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
                input_required = attribute_data.fetch(:required).fetch(:is)
                return true unless input_required

                prepared_attributes = attributes.dup
                prepared_attributes[attribute_name] = nil

                input_required_message = attribute_data.fetch(:required).fetch(:message)

                if input_required_message.nil?
                  input_required_message = I18n.t(
                    "#{i18n_root_key}.inputs.validations.required.default_error.default",
                    service_class_name: described_class.name,
                    input_name: attribute_name
                  )
                end

                expect_failure_with!(prepared_attributes, input_required_message)
              end

              # Checks that optional input accepts nil without failure.
              #
              # @return [Boolean] True if service doesn't fail on nil optional
              def failure_optional_passes?
                input_required = attribute_data.fetch(:required).fetch(:is)
                return true if input_required

                prepared_attributes = attributes.dup
                prepared_attributes[attribute_name] = nil

                expect_failure_with!(prepared_attributes, nil)
              end

              # Checks that inclusion validation fails with wrong value.
              #
              # @return [Boolean] True if inclusion validation fails as expected
              def failure_inclusion_passes? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
                input_inclusion_in = attribute_data.dig(:inclusion, :in)
                return true if input_inclusion_in.blank?

                wrong_value = generate_wrong_value_for_inclusion(input_inclusion_in)

                prepared_attributes = attributes.dup
                prepared_attributes[attribute_name] = wrong_value

                input_required_message = attribute_data.fetch(:inclusion).fetch(:message)

                # If message is a Proc, we can't easily evaluate it in the test context
                # (it may require runtime args like input:, value:), so skip message comparison
                if input_required_message.is_a?(Proc)
                  return expect_failure_with!(prepared_attributes, :skip_message_check)
                end

                if input_required_message.nil?
                  input_required_message = I18n.t(
                    "#{i18n_root_key}.inputs.validations.must.dynamic_options.inclusion.default",
                    service_class_name: described_class.name,
                    input_name: attribute_name,
                    input_inclusion: input_inclusion_in.inspect,
                    value: wrong_value.inspect
                  )
                end

                expect_failure_with!(prepared_attributes, input_required_message)
              end

              # Checks that target validation fails with wrong value.
              #
              # @return [Boolean] True if target validation fails as expected
              def failure_target_passes? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
                input_target_in = attribute_data.dig(:target, :in)
                return true if input_target_in.blank?

                target_values = input_target_in.is_a?(Array) ? input_target_in : [input_target_in]
                wrong_value = Servactory::TestKit::Utils::Faker.fetch_value_for(target_values.first.class)

                prepared_attributes = attributes.dup
                prepared_attributes[attribute_name] = wrong_value

                input_required_message = attribute_data.fetch(:target).fetch(:message)

                # If message is a Proc, we can't easily evaluate it in the test context
                # (it may require runtime args like input:, value:), so skip message comparison
                if input_required_message.is_a?(Proc)
                  return expect_failure_with!(prepared_attributes, :skip_message_check)
                end

                if input_required_message.nil?
                  input_required_message = I18n.t(
                    "#{i18n_root_key}.inputs.validations.must.dynamic_options.target.default",
                    service_class_name: described_class.name,
                    input_name: attribute_name,
                    expected_target: input_target_in.inspect,
                    value: wrong_value.inspect
                  )
                end

                expect_failure_with!(prepared_attributes, input_required_message)
              end

              # Calls service and verifies it fails with expected message.
              #
              # @param prepared_attributes [Hash] Attributes to pass to service
              # @param expected_message [String, Symbol, nil] Expected error message
              # @return [Boolean] True if service fails with expected message
              def expect_failure_with!(prepared_attributes, expected_message)
                described_class.call!(prepared_attributes).success?
              rescue Servactory::Exceptions::Input => e
                return true if expected_message == :skip_message_check # Just verify error was raised
                return false if expected_message.blank?

                message_to_compare = expected_message.is_a?(Proc) ? expected_message.call : expected_message
                message_to_compare.to_s.casecmp(e.message.to_s).zero?
              rescue Servactory::Exceptions::Internal, Servactory::Exceptions::Output
                true
              end

              # Generates a value that is outside the inclusion set.
              # Handles Range, Array, and scalar values.
              #
              # @param inclusion_value [Range, Array, Object] The inclusion constraint
              # @return [Object] A value guaranteed to be outside the inclusion set
              def generate_wrong_value_for_inclusion(inclusion_value)
                case inclusion_value
                when Range
                  generate_wrong_value_for_range(inclusion_value)
                when Array
                  Servactory::TestKit::Utils::Faker.fetch_value_for(inclusion_value.first.class)
                else
                  Servactory::TestKit::Utils::Faker.fetch_value_for(inclusion_value.class)
                end
              end

              # Generates a value outside a Range.
              #
              # @param range [Range] The range constraint
              # @return [Object] A value outside the range
              def generate_wrong_value_for_range(range)
                if range.begin.nil?
                  # Beginless range (..100): use value above end
                  range.end + 1
                elsif range.end.nil?
                  # Endless range (1..): use value below begin
                  range.begin - 1
                else
                  # Normal range: use value above end
                  range.exclude_end? ? range.end : range.end + 1
                end
              end
            end
          end
        end
      end
    end
  end
end
