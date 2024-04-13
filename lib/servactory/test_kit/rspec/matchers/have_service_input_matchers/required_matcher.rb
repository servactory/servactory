# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class RequiredMatcher
            attr_reader :missing_option

            def initialize(described_class, input_name, custom_message)
              @described_class = described_class
              @input_name = input_name
              @custom_message = custom_message

              @missing_option = ""
            end

            def description
              "required: true"
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

            attr_reader :described_class, :input_name, :custom_message

            def submatcher_passes?(_subject) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              input_data = described_class.info.inputs.fetch(input_name)
              input_required = input_data.fetch(:required).fetch(:is)
              input_required_message = input_data.fetch(:required).fetch(:message)

              matched = input_required == true

              if input_required_message.nil?
                input_required_message = I18n.t(
                  "servactory.inputs.validations.required.default_error.default",
                  service_class_name: described_class.name,
                  input_name: input_name
                )
              end

              matched &&= input_required_message.casecmp(custom_message).zero? if custom_message.present?

              matched
            end

            def build_missing_option
              "should be required"
            end
          end
        end
      end
    end
  end
end
