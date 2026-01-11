# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        module Concerns
          # Pure Ruby module for building validation errors.
          #
          # Provides shared logic for processing error messages (String or Proc)
          # and creating Errors collections.
          #
          # @example Including in a validator
          #   class MyValidator
          #     extend Concerns::ErrorBuilder
          #   end
          module ErrorBuilder
            # Processes a message that may be a String or Proc.
            #
            # @param message [String, Proc] The message to process
            # @param attributes [Hash] Attributes to pass to Proc if message is callable
            # @return [String] The processed message string
            def process_message(message, **attributes)
              return message unless message.is_a?(Proc)

              message.call(**attributes)
            end

            # Creates an Errors collection with a single processed message.
            #
            # @param message [String, Proc] The error message
            # @param attributes [Hash] Attributes for Proc message processing
            # @return [Errors] Errors collection containing the processed message
            def build_errors(message, **attributes)
              errors = Errors.new
              errors << process_message(message, **attributes)
              errors
            end
          end
        end
      end
    end
  end
end
