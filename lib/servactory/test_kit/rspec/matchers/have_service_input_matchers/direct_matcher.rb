# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class DirectMatcher
            attr_reader :missing_option

            def initialize(described_class, input_name, attributes)
              @described_class = described_class
              @input_name = input_name
              @attributes = attributes

              @input_data = described_class.info.inputs.fetch(input_name)

              @missing_option = ""
            end

            def description
              "direct: ..."
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
              required? &&
                optional? &&
                consists_of?
            end

            def required? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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

              described_class.call!(attributes)

              false
            rescue ApplicationService::Exceptions::Input => e
              input_required_message.casecmp(e.message).zero?
            rescue ApplicationService::Exceptions::Internal, ApplicationService::Exceptions::Output
              # NOTE: Skips the fall of validations inside the service, which are not important in this place.
              true
            end

            def optional?
              input_required = input_data.fetch(:required).fetch(:is)

              return true if input_required

              attributes[input_name] = nil

              described_class.call!(attributes)

              true
            rescue ApplicationService::Exceptions::Input => _e
              false
            rescue ApplicationService::Exceptions::Internal, ApplicationService::Exceptions::Output
              # NOTE: Skips the fall of validations inside the service, which are not important in this place.
              true
            end

            def consists_of? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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
                  given_type: attributes[input_name].map(&:class).join(", ")
                )
              end

              described_class.call!(attributes)

              false
            rescue ApplicationService::Exceptions::Input => e
              input_consists_of_message.casecmp(e.message).zero?
            rescue ApplicationService::Exceptions::Internal, ApplicationService::Exceptions::Output
              # NOTE: Skips the fall of validations inside the service, which are not important in this place.
              true
            end

            def build_missing_option
              "should be ..."
            end
          end
        end
      end
    end
  end
end
