# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      module Concerns
        # Concern providing error message processing for validators.
        #
        # ## Purpose
        #
        # ErrorBuilder provides shared logic for processing error messages that
        # can be either static strings or dynamic Procs. This allows validators
        # to support both simple error messages and context-aware messages.
        #
        # ## Usage
        #
        # Extend in validator classes:
        #
        # ```ruby
        # class MyValidator
        #   extend Concerns::ErrorBuilder
        #
        #   def self.build_error(...)
        #     process_message(message, **context)
        #   end
        # end
        # ```
        #
        # ## Methods Provided
        #
        # - `process_message` - converts String or Proc message to String
        module ErrorBuilder
          # Processes a message that may be a String or Proc.
          #
          # If message is a Proc, calls it with the provided attributes.
          # If message is a String, returns it unchanged.
          #
          # @param message [String, Proc] The message to process
          # @param attributes [Hash] Attributes to pass to Proc if message is callable
          # @return [String] The processed message string
          def process_message(message, **attributes)
            return message unless message.is_a?(Proc)

            message.call(**attributes)
          end
        end
      end
    end
  end
end
