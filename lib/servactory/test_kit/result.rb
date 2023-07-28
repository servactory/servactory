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
        attributes.each_pair do |name, value|
          servactory_service_storage[:outputs].merge!({ name => value })
        end
      end

      private_class_method :new

      private

      def servactory_service_storage
        @servactory_service_storage ||= { outputs: {} }
      end
    end
  end
end
