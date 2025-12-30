# frozen_string_literal: true

module ApplicationService
  module Extensions
    module ExternalApiRequest
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          attr_accessor :external_api_request_config

          def external_api_request!(response_type:, error_class:)
            self.external_api_request_config = {
              response_type: response_type,
              error_class: error_class
            }

            output :response, type: response_type

            make :perform_api_request!
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super
          rescue StandardError => e
            config = self.class.send(:external_api_request_config)
            error_class = config&.dig(:error_class)

            if error_class && e.is_a?(error_class)
              fail!(message: e.message, meta: { original_exception: e })
            else
              raise
            end
          end

          def perform_api_request!
            outputs.response = api_request
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
