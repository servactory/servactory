# frozen_string_literal: true

module Servactory
  module TestKit
    class Result
      def self.as_success(attributes = {})
        Servactory::Result.success_for(context: new(attributes))
      end

      def self.as_failure(exception: nil)
        Servactory::Result.failure_for(exception: exception)
      end

      def initialize(attributes = {})
        attributes.each_pair do |method_name, method_return|
          service_storage[:outputs].merge!({ method_name => method_return })
        end
      end

      private

      def service_storage
        @service_storage ||= { outputs: {} }
      end
    end
  end
end
