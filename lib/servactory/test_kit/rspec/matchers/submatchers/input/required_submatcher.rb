# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Input
            class RequiredSubmatcher < Base::Submatcher
              def initialize(context, custom_message = nil)
                super(context)
                @custom_message = custom_message
              end

              def description
                "required: true"
              end

              protected

              def passes?
                required_data = attribute_data.fetch(:required)
                is_required = required_data.fetch(:is)

                return false unless is_required == true
                return true unless custom_message.present?

                actual_message = required_data.fetch(:message) || default_required_message
                actual_message.casecmp(custom_message).zero?
              end

              def build_failure_message
                <<~MESSAGE
                  should be required

                    expected required: true
                         got required: false
                MESSAGE
              end

              private

              attr_reader :custom_message

              def default_required_message
                I18n.t(
                  "#{i18n_root_key}.inputs.validations.required.default_error.default",
                  service_class_name: described_class.name,
                  input_name: attribute_name
                )
              end
            end
          end
        end
      end
    end
  end
end
