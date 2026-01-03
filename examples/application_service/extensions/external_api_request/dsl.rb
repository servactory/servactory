# frozen_string_literal: true

module ApplicationService
  module Extensions
    module ExternalApiRequest
      # Wraps service as an external API request handler.
      #
      # ## Purpose
      #
      # Provides consistent handling for services that call external APIs.
      # Catches API-specific errors and converts them to service failures.
      # Uses isolated extension configuration to store API settings.
      #
      # ## Usage
      #
      # ```ruby
      # class FetchUserDataService < ApplicationService::Base
      #   external_api_request! response_type: UserData, error_class: ApiError
      #
      #   input :user_id, type: Integer
      #
      #   private
      #
      #   def api_request
      #     api_client.get("/users/#{inputs.user_id}")
      #   end
      #
      #   def api_client
      #     ExternalApi::Client.new
      #   end
      # end
      # ```
      #
      # ## Configuration Isolation
      #
      # This extension uses isolated config namespace to prevent collisions:
      #
      # ```ruby
      # extension_config(:actions, :external_api_request)[:response_type] = UserData
      # extension_config(:actions, :external_api_request)[:error_class] = ApiError
      # ```
      #
      # ## Shared Access (if needed)
      #
      # Extensions can coordinate by reading other configs:
      #
      # ```ruby
      # # retry_config = extension_config(:actions, :retryable)
      # # if retry_config[:enabled]
      # #   # coordinate with retryable extension
      # # end
      # ```
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          def external_api_request!(response_type:, error_class:)
            extension_config(:actions, :external_api_request)[:response_type] = response_type
            extension_config(:actions, :external_api_request)[:error_class] = error_class

            output :api_response, type: response_type

            make :perform_api_request!
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super
          rescue StandardError => e
            config = self.class.extension_config(:actions, :external_api_request)
            error_class = config[:error_class]

            raise e if error_class.nil?
            raise e unless e.is_a?(error_class)

            fail!(:external_api_error, message: e.message, meta: { original_exception: e })
          end

          def perform_api_request!
            outputs.api_response = api_request
          end

          def api_request
            fail!(message: "Need to specify the API request")
          end

          def api_model
            fail!(message: "Need to specify the API model")
          end

          def api_client
            fail!(message: "Need to specify the API client")
          end
        end
      end
    end
  end
end
