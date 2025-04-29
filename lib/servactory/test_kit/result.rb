# frozen_string_literal: true

module Servactory
  module TestKit
    class Result
      def self.as_success(**attributes)
        service_class = attributes.delete(:service_class) || self

        context = new(attributes)

        if service_class == Servactory::TestKit::Result
          Servactory::Result.success_for(context:)
        else
          service_class.config.result_class.success_for(context:)
        end
      end

      def self.as_failure(**attributes)
        service_class = attributes.delete(:service_class) || self
        exception = attributes.delete(:exception)

        context = new(attributes)

        if service_class == Servactory::TestKit::Result
          Servactory::Result.failure_for(context:, exception:)
        else
          service_class.config.result_class.failure_for(context:, exception:)
        end
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
