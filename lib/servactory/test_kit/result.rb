# frozen_string_literal: true

module Servactory
  module TestKit
    # Factory for creating mock Servactory result objects.
    #
    # ## Purpose
    #
    # Provides factory methods for creating success and failure result objects
    # in tests without actually calling a service. Used internally by the
    # service mocking helpers to generate return values.
    #
    # ## Usage
    #
    # ```ruby
    # # Create success result with outputs
    # result = Servactory::TestKit::Result.as_success(
    #   service_class: MyService,
    #   user: user_object,
    #   status: :active
    # )
    #
    # # Create failure result with exception
    # result = Servactory::TestKit::Result.as_failure(
    #   service_class: MyService,
    #   exception: Servactory::Exceptions::Failure.new(message: "Error")
    # )
    # ```
    #
    # ## Service Class Resolution
    #
    # When `service_class` is provided, uses that service's configured
    # `result_class` for proper result type. Otherwise, uses the default
    # `Servactory::Result` class.
    class Result
      # Creates a successful mock result with given outputs.
      #
      # @param attributes [Hash] Output attributes and optional :service_class
      # @return [Servactory::Result] Success result with outputs as methods
      def self.as_success(**attributes)
        service_class = attributes.delete(:service_class) || self

        context = new(attributes)

        if service_class == Servactory::TestKit::Result
          Servactory::Result.success_for(context:)
        else
          service_class.config.result_class.success_for(context:)
        end
      end

      # Creates a failed mock result with given exception.
      #
      # @param attributes [Hash] Output attributes, :exception, and optional :service_class
      # @return [Servactory::Result] Failure result with error accessor
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

      # Initializes result with attribute accessors.
      #
      # @param attributes [Hash] Output name-value pairs
      # @return [Result] New result instance
      def initialize(attributes = {})
        attributes.each_pair do |name, value|
          servactory_service_warehouse.assign_output(name, value)
        end
      end

      private_class_method :new

      private

      # Internal warehouse for storing output values.
      #
      # @return [Servactory::Context::Warehouse::Setup] Warehouse instance
      def servactory_service_warehouse
        @servactory_service_warehouse ||= Servactory::Context::Warehouse::Setup.new(self)
      end
    end
  end
end
