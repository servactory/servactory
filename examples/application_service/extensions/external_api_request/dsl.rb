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
              response_type:,
              error_class:
            }

            output :api_response, type: response_type

            make :perform_api_request!
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super
          rescue StandardError => e
            _handle_external_api_error(exception: e)
          end

          def _handle_external_api_error(exception:)
            config = self.class.send(:external_api_request_config)

            raise exception if config.nil?

            error_class = config[:error_class]

            raise exception unless exception.is_a?(error_class)

            fail!(:external_api_error, message: exception.message, meta: { original_exception: exception })
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
