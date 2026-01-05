# frozen_string_literal: true

module Usual
  module Extensions
    module ApiAction
      class Example1 < ApplicationService::Base
        LikeAnHttpClient = Class.new do
          class << self
            attr_accessor :request_count

            def reset!
              self.request_count = 0
            end

            def get(url)
              self.request_count ||= 0
              self.request_count += 1

              { success: true, data: { id: 1, name: "User from #{url}" } }
            end
          end
        end

        input :user_id, type: Integer

        internal :response, type: Hash

        output :user_data, type: Hash

        api_action :fetch_user

        private

        def perform_fetch_user_request
          internals.response = LikeAnHttpClient.get("/users/#{inputs.user_id}")
        end

        def handle_fetch_user_response!
          response = internals.response

          fail!(:api_error, message: "Request failed") unless response[:success]

          outputs.user_data = response[:data]
        end
      end
    end
  end
end
