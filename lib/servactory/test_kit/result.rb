# frozen_string_literal: true

module Servactory
  module TestKit
    class Result
      def self.as_success(attributes = {})
        context = new(attributes)

        Servactory::Result.success_for(context:)
      end

      def self.as_failure(attributes = {}, exception: nil)
        context = new(attributes)

        Servactory::Result.failure_for(context:, exception:)
      end

      def initialize(attributes = {})
        attributes.each_pair do |name, value|
          servactory_service_warehouse.assign_output(name, value)
        end
      end

      private_class_method :new

      private

      def servactory_service_warehouse
        @servactory_service_warehouse ||= Servactory::Context::Warehouse::Setup.new(self)
      end
    end
  end
end
