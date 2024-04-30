# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class ValidWithMatcher # rubocop:disable Metrics/ClassLength
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, attributes)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @attributes = attributes

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

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
                        :attribute_data

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
              input_first_type = option_types.first
              input_required = attribute_data.fetch(:required).fetch(:is)
              attribute_consists_of_types = Array(attribute_data.fetch(:consists_of).fetch(:type))
              attribute_consists_of_first_type = attribute_consists_of_types.first

              prepared_attributes = attributes.dup
              prepared_attributes[attribute_name] = Servactory::TestKit::FakeType.new

              input_required_message =
                if described_class.config.collection_mode_class_names.include?(input_first_type) &&
                   attribute_consists_of_first_type != false
                  if input_required
                    I18n.t(
                      "servactory.#{attribute_type_plural}.validations.required.default_error.for_collection",
                      service_class_name: described_class.name,
                      "#{attribute_type}_name": attribute_name
                    )
                  else
                    I18n.t(
                      "servactory.#{attribute_type_plural}.validations.type.default_error.for_collection.wrong_type",
                      service_class_name: described_class.name,
                      "#{attribute_type}_name": attribute_name,
                      expected_type: option_types.join(", "),
                      given_type: Servactory::TestKit::FakeType.new.class.name
                    )
                  end
                else
                  I18n.t(
                    "servactory.#{attribute_type_plural}.validations.type.default_error.default",
                    service_class_name: described_class.name,
                    "#{attribute_type}_name": attribute_name,
                    expected_type: option_types.join(", "),
                    given_type: Servactory::TestKit::FakeType.new.class.name
                  )
                end

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
                  "servactory.#{attribute_type_plural}.validations.required.default_error.default",
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

            def failure_format_passes?
              # NOTE: Checking for negative cases is not implemented for `format`
              true
            end

            def failure_consists_of_passes? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              option_types = attribute_data.fetch(:types)
              input_first_type = option_types.first

              return true unless described_class.config.collection_mode_class_names.include?(input_first_type)

              prepared_attributes = attributes.dup
              prepared_attributes[attribute_name] = input_first_type[Servactory::TestKit::FakeType.new]

              attribute_consists_of_types = Array(attribute_data.fetch(:consists_of).fetch(:type))
              attribute_consists_of_first_type = attribute_consists_of_types.first

              return true if attribute_consists_of_first_type == false

              attribute_consists_of_message = attribute_data.fetch(:consists_of).fetch(:message)

              if attribute_consists_of_message.nil?
                attribute_consists_of_message = I18n.t(
                  "servactory.#{attribute_type_plural}.validations.type.default_error.for_collection.wrong_element_type", # rubocop:disable Layout/LineLength
                  service_class_name: described_class.name,
                  "#{attribute_type}_name": attribute_name,
                  expected_type: attribute_consists_of_types.join(", "),
                  given_type: prepared_attributes[attribute_name].map { _1.class.name }.join(", ")
                )
              end

              expect_failure_with!(prepared_attributes, attribute_consists_of_message)
            end

            def failure_inclusion_passes? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              input_inclusion_in = attribute_data.fetch(:inclusion).fetch(:in)

              return true if input_inclusion_in.blank?

              wrong_value = Servactory::TestKit::Utils::Faker.fetch_value_for(input_inclusion_in.first.class)

              prepared_attributes = attributes.dup
              prepared_attributes[attribute_name] = wrong_value

              input_required_message = attribute_data.fetch(:inclusion).fetch(:message)

              if input_required_message.nil?
                input_required_message = I18n.t(
                  "servactory.#{attribute_type_plural}.validations.inclusion.default_error",
                  service_class_name: described_class.name,
                  "#{attribute_type}_name": attribute_name,
                  "#{attribute_type}_inclusion": input_inclusion_in,
                  value: wrong_value
                )
              elsif input_required_message.is_a?(Proc)
                input_work = attribute_data.fetch(:work)

                input_required_message = input_required_message.call(
                  service_class_name: described_class.name,
                  input: input_work,
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
              service_result = described_class.call!(prepared_attributes)

              if described_class.config.validation_mode_bang_without_throwing_exception_for_attributes?
                return service_result.success? || service_result.failure?
              end

              service_result.success?
            rescue Servactory::Exceptions::Input
              false
            rescue StandardError
              true
            end

            def expect_failure_with!(prepared_attributes, expected_message)
              service_result = described_class.call!(prepared_attributes)

              if described_class.config.validation_mode_bang_without_throwing_exception_for_attributes?
                return service_result.success? || service_result.failure?
              end

              service_result.success?
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
