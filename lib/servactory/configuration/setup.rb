# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      def self.build_for(service_class)
        store = Store.new

        servactory_ancestors_for(service_class).reverse_each do |ancestor|
          apply_service_configuration_for(store, ancestor)
        end

        store
      end

      def self.apply_service_configuration_for(store, service_class)
        # Apply config from `configuration do ... end` block
        configuration_block = service_class.configuration_block
        if configuration_block.present?
          factory = Factory.new(store)
          factory.instance_eval(&configuration_block)
        end

        # Apply config from `fail_on!` calls
        store.action_rescue_handlers += service_class.action_rescue_handlers_class_attr
      end

      def self.servactory_ancestors_for(service_class)
        service_class.ancestors.take_while do |ancestor|
          ancestor.respond_to?(:configuration_block)
        end
      end

      def initialize(context)
        @context = context
      end

      def method_missing(name, *_args)
        configuration_store.public_send(name)
      end

      def respond_to_missing?(name, include_private = false)
        configuration_store.respond_to?(name, include_private) || super
      end

      private

      def configuration_store
        @configuration_store ||= self.class.build_for(@context.class)
      end
    end
  end
end
