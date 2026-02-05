# frozen_string_literal: true

module Wrong
  module Extensions
    module ExternalApiRequest
      class Example1 < ApplicationService::Base
        class LikeAFaradayError < StandardError; end

        LikeAnApiResponse = Struct.new(:id, :name, keyword_init: true)

        LikeAnApiClient = Class.new do
          class << self
            attr_accessor :request_count

            def reset!
              self.request_count = 0
            end

            def users
              @users ||= new
            end
          end

          def fetch(id:)
            self.class.request_count ||= 0
            self.class.request_count += 1

            raise LikeAFaradayError, "Connection failed for user #{id}"
          end
        end

        input :user_id, type: Integer

        external_api_request!(
          response_type: LikeAnApiResponse,
          error_class: LikeAFaradayError
        )

        private

        def api_client
          LikeAnApiClient
        end

        def api_request
          api_client.users.fetch(id: inputs.user_id)
        end
      end
    end
  end
end
