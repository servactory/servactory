# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          # Concern for building the message of the `required` option of an input.
          #
          # ## Purpose
          #
          # RequiredMessage builds the message the library uses for a missing
          # required value, so submatchers that check it build it the same way.
          #
          # ## Usage
          #
          # ```ruby
          # class MySubmatcher < Base::Submatcher
          #   include Concerns::RequiredMessage
          #
          #   def passes?
          #     required_message == "Name is mandatory"
          #   end
          # end
          # ```
          #
          # ## Methods Provided
          #
          # - `required_custom_message` - the custom message as defined
          # - `default_required_message` - the default message of the library
          # - `call_required_message` - builds a Proc message
          # - `required_message` - the message used for a missing value
          module RequiredMessage
            # Includes InstanceMethods in the including class.
            #
            # @param base [Class] The class including this concern
            # @return [void]
            def self.included(base)
              base.include(InstanceMethods)
            end

            # Instance methods added by this concern.
            module InstanceMethods
              # Returns the custom message from `required: { message: }`.
              #
              # @return [String, Proc, nil] The custom message as defined
              def required_custom_message
                attribute_data.fetch(:required).fetch(:message)
              end

              # Generates the default I18n message for required validation.
              #
              # @return [String] Localized default required message
              def default_required_message
                I18n.t(
                  "#{i18n_root_key}.inputs.validations.required.default_error.default",
                  service_class_name: described_class.name,
                  input_name: attribute_name
                )
              end

              # Calls a Proc message with the keyword arguments the library passes to it.
              #
              # `value:` is `nil`, as for a missing value.
              #
              # @param message [Proc] The custom message
              # @return [Object] The message built by the Proc
              def call_required_message(message)
                message.call(
                  service: described_class.send(:new).send(:servactory_service_info),
                  input: attribute_data.fetch(:actor),
                  value: nil
                )
              end

              # Builds the message the library uses for a missing required value.
              #
              # Uses the custom message if provided, otherwise the default message.
              #
              # @return [Object] The message, a String unless a Proc message returns another object
              def required_message
                message = required_custom_message

                return default_required_message if message.blank?
                return message unless message.is_a?(Proc)

                call_required_message(message)
              end
            end
          end
        end
      end
    end
  end
end
