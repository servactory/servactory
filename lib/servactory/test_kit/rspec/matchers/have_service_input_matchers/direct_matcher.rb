# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class DirectMatcher # rubocop:disable Metrics/ClassLength
            attr_reader :missing_option

            def initialize(described_class, input_name, attributes)
              @described_class = described_class
              @input_name = input_name
              @attributes = attributes

              @input_data = described_class.info.inputs.fetch(input_name)

              @missing_option = ""
            end

            def description
              "direct attribute checking"
            end

            def matches?(subject)
              if submatcher_passes?(subject)
                true
              else
                @missing_option = build_missing_option

                false
              end
            end

            private

            attr_reader :described_class, :input_name, :attributes, :input_data

            def submatcher_passes?(_subject)
              type_passes? &&
                required_passes? &&
                optional_passes? &&
                consists_of_passes?
            end

            def type_passes? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              input_types = input_data.fetch(:types)
              input_first_type = input_types.first
              input_required = input_data.fetch(:required).fetch(:is)
              input_consists_of_types = input_data.fetch(:consists_of).fetch(:type)

              attributes[input_name] = Servactory::TestKit::FakeType.new

              input_required_message =
                if described_class.config.collection_mode_class_names.include?(input_first_type) &&
                   input_consists_of_types != false
                  if input_required
                    I18n.t(
                      "servactory.inputs.validations.required.default_error.for_collection",
                      service_class_name: described_class.name,
                      input_name: input_name
                    )
                  else
                    I18n.t(
                      "servactory.inputs.validations.type.default_error.for_collection.wrong_type",
                      service_class_name: described_class.name,
                      input_name: input_name,
                      expected_type: input_types.join(", "),
                      given_type: Servactory::TestKit::FakeType.new.class.name
                    )
                  end
                else
                  I18n.t(
                    "servactory.inputs.validations.type.default_error.default",
                    service_class_name: described_class.name,
                    input_name: input_name,
                    expected_type: input_types.join(", "),
                    given_type: Servactory::TestKit::FakeType.new.class.name
                  )
                end

              described_class.call!(attributes).success?
            rescue Servactory::Exceptions::Input => e
              input_required_message.casecmp(e.message).zero?
            rescue Servactory::Exceptions::Internal, Servactory::Exceptions::Output
              # NOTE: Skips the fall of validations inside the service, which are not important in this place.
              true
            end

            def required_passes? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              input_required = input_data.fetch(:required).fetch(:is)

              return true unless input_required

              attributes[input_name] = nil

              input_required_message = input_data.fetch(:required).fetch(:message)

              if input_required_message.nil?
                input_required_message = I18n.t(
                  "servactory.inputs.validations.required.default_error.default",
                  service_class_name: described_class.name,
                  input_name: input_name
                )
              end

              described_class.call!(attributes).success?
            rescue Servactory::Exceptions::Input => e
              input_required_message.casecmp(e.message).zero?
            rescue Servactory::Exceptions::Internal, Servactory::Exceptions::Output
              # NOTE: Skips the fall of validations inside the service, which are not important in this place.
              true
            end

            def optional_passes?
              input_required = input_data.fetch(:required).fetch(:is)

              return true if input_required

              attributes[input_name] = nil

              described_class.call!(attributes).success?
            rescue ApplicationService::Exceptions::Input => _e
              false
            rescue Servactory::Exceptions::Internal, Servactory::Exceptions::Output
              # NOTE: Skips the fall of validations inside the service, which are not important in this place.
              true
            end

            def consists_of_passes? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              input_types = input_data.fetch(:types)
              input_first_type = input_types.first

              return true unless described_class.config.collection_mode_class_names.include?(input_first_type)

              attributes[input_name] = input_first_type[Servactory::TestKit::FakeType.new]

              input_consists_of_types = Array(input_data.fetch(:consists_of).fetch(:type))
              input_consists_of_message = input_data.fetch(:consists_of).fetch(:message)

              if input_consists_of_message.nil?
                input_consists_of_message = I18n.t(
                  "servactory.inputs.validations.type.default_error.for_collection.wrong_element_type",
                  service_class_name: described_class.name,
                  input_name: input_name,
                  expected_type: input_consists_of_types.join(", "),
                  given_type: attributes[input_name].map { _1.class.name }.join(", ")
                )
              end

              described_class.call!(attributes).success?
            rescue Servactory::Exceptions::Input => e
              input_consists_of_message.casecmp(e.message).zero?
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
