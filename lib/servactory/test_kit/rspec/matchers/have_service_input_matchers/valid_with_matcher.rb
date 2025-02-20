# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          # DEPRECATED: This chain is planned to be decommissioned.
          class ValidWithMatcher # rubocop:disable Metrics/ClassLength
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, attributes)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @attributes = attributes.is_a?(FalseClass) ? attributes : Servactory::Utils.adapt(attributes)

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @i18n_root_key = described_class.config.i18n_root_key

              @missing_option = ""
            end

            def description
              "valid_with attribute checking"
            end

            def matches?(subject)
              if attributes.is_a?(FalseClass) || submatcher_passes?(subject)
                true
              else
                @missing_option = build_missing_option

                false
              end
            end

            private

            attr_reader :described_class,
                        :attribute_type,
                        :attribute_type_plural,
                        :attribute_name,
                        :attributes,
                        :attribute_data,
                        :i18n_root_key

            def submatcher_passes?(_subject) # rubocop:disable Metrics/CyclomaticComplexity
              success_passes? &&
                failure_type_passes? &&
                failure_required_passes? &&
                failure_optional_passes? &&
                failure_consists_of_passes? &&
                failure_format_passes? &&
                failure_inclusion_passes? &&
                failure_must_passes?
            end

            def success_passes?
              expect_success_with!(attributes)
            end

            def failure_type_passes? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              option_types = attribute_data.fetch(:types)

              prepared_attributes = attributes.dup
              prepared_attributes[attribute_name] = Servactory::TestKit::FakeType.new

              input_required_message =
                I18n.t(
                  "#{i18n_root_key}.#{attribute_type_plural}.validations.type.default_error.default",
                  service_class_name: described_class.name,
                  "#{attribute_type}_name": attribute_name,
                  expected_type: option_types.join(", "),
                  given_type: Servactory::TestKit::FakeType.new.class.name
                )

              expect_failure_with!(prepared_attributes, input_required_message)
            end

            def failure_required_passes? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              input_required = attribute_data.fetch(:required).fetch(:is)

              return true unless input_required

              prepared_attributes = attributes.dup
              prepared_attributes[attribute_name] = nil

              input_required_message = attribute_data.fetch(:required).fetch(:message)

              if input_required_message.nil?
                input_required_message = I18n.t(
                  "#{i18n_root_key}.#{attribute_type_plural}.validations.required.default_error.default",
                  service_class_name: described_class.name,
                  "#{attribute_type}_name": attribute_name
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

            def failure_consists_of_passes?
              # NOTE: Checking for negative cases is not implemented for `consists_of`
              true
            end

            def failure_format_passes?
              # NOTE: Checking for negative cases is not implemented for `format`
              true
            end

            def failure_inclusion_passes? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              input_inclusion_in = attribute_data.fetch(:inclusion, {}).fetch(:in, nil)

              return true if input_inclusion_in.blank?

              wrong_value = Servactory::TestKit::Utils::Faker.fetch_value_for(input_inclusion_in.first.class)

              prepared_attributes = attributes.dup
              prepared_attributes[attribute_name] = wrong_value

              input_required_message = attribute_data.fetch(:inclusion).fetch(:message)

              if input_required_message.nil?
                input_required_message = I18n.t(
                  "#{i18n_root_key}.#{attribute_type_plural}.validations.must.dynamic_options.inclusion.default",
                  service_class_name: described_class.name,
                  "#{attribute_type}_name": attribute_name,
                  "#{attribute_type}_inclusion": input_inclusion_in.inspect,
                  value: wrong_value.inspect
                )
              elsif input_required_message.is_a?(Proc)
                service_class = Struct.new(:class_name, keyword_init: true)
                service = service_class.new(class_name: described_class.name)

                input_actor = attribute_data.fetch(:actor)

                input_required_message = input_required_message.call(
                  service:,
                  input: input_actor,
                  value: wrong_value
                )
              end

              expect_failure_with!(prepared_attributes, input_required_message)
            end

            def failure_must_passes?
              # NOTE: Checking for negative cases is not implemented for `must`
              true
            end

            def expect_success_with!(prepared_attributes)
              described_class.call!(prepared_attributes).success?
            rescue Servactory::Exceptions::Input
              false
            rescue StandardError
              true
            end

            def expect_failure_with!(prepared_attributes, expected_message)
              described_class.call!(prepared_attributes).success?
            rescue Servactory::Exceptions::Input => e
              return false if expected_message.blank?

              expected_message.casecmp(e.message).zero?
            rescue Servactory::Exceptions::Internal, Servactory::Exceptions::Output
              # NOTE: Skips the fall of validations inside the service, which are not important in this place.
              true
            end

            def build_missing_option
              "should work as expected on the specified attributes based on its options"
            end
          end
        end
      end
    end
  end
end
