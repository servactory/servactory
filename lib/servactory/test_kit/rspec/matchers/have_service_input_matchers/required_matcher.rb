# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class RequiredMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, custom_message)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @custom_message = custom_message

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

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

            attr_reader :described_class,
                        :attribute_type,
                        :attribute_type_plural,
                        :attribute_name,
                        :custom_message,
                        :attribute_data

            def submatcher_passes?(_subject) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              attribute_required = attribute_data.fetch(:required).fetch(:is)
              attribute_required_message = attribute_data.fetch(:required).fetch(:message)

              matched = attribute_required == true

              if attribute_required_message.nil?
                attribute_required_message = I18n.t(
                  "servactory.#{attribute_type_plural}.validations.required.default_error.default",
                  service_class_name: described_class.name,
                  "#{attribute_type}_name": attribute_name
                )
              end

              matched &&= attribute_required_message.casecmp(custom_message).zero? if custom_message.present?

              matched
            end

            def build_missing_option
              <<~MESSAGE
                should be required

                  expected required: true
                       got required: false
              MESSAGE
            end
          end
        end
      end
    end
  end
end
