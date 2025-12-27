# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Input
            # DEPRECATED: This submatcher is planned to be decommissioned.
            class ValidWithSubmatcher < Base::Submatcher # rubocop:disable Metrics/ClassLength
              def initialize(context, attributes)
                super(context)
                @attributes = attributes.is_a?(FalseClass) ? attributes : Servactory::Utils.adapt(attributes)
              end

              def description
                "valid_with attribute checking"
              end

              protected

              def passes?
                return true if attributes.is_a?(FalseClass)

                success_passes? &&
                  failure_type_passes? &&
                  failure_required_passes? &&
                  failure_optional_passes? &&
                  failure_inclusion_passes? &&
                  failure_target_passes?
              end

              def build_failure_message
                "should work as expected on the specified attributes based on its options"
              end

              private

              attr_reader :attributes

              def success_passes?
                described_class.call!(attributes).success?
              rescue Servactory::Exceptions::Input
                false
              rescue StandardError
                true
              end

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

              def failure_optional_passes?
                input_required = attribute_data.fetch(:required).fetch(:is)
                return true if input_required

                prepared_attributes = attributes.dup
                prepared_attributes[attribute_name] = nil

                expect_failure_with!(prepared_attributes, nil)
              end

              def failure_inclusion_passes? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
                input_inclusion_in = attribute_data.dig(:inclusion, :in)
                return true if input_inclusion_in.blank?

                wrong_value = Servactory::TestKit::Utils::Faker.fetch_value_for(input_inclusion_in.first.class)

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

              def failure_target_passes? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
                input_target_in = attribute_data.dig(:target, :in)
                return true if input_target_in.blank?

                wrong_value = Servactory::TestKit::Utils::Faker.fetch_value_for(input_target_in.first.class)

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
            end
          end
        end
      end
    end
  end
end
