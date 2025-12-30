# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Rollbackable
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        def self.register_hooks(service_class)
          service_class.on_failure(:_perform_rollback, priority: 0)
        end

        module ClassMethods
          private

          attr_accessor :rollback_method_name

          def on_rollback(method_name)
            self.rollback_method_name = method_name
          end
        end

        module InstanceMethods
          private

          def _perform_rollback(exception:, **) # rubocop:disable Lint/UnusedMethodArgument
            rollback_method_name = self.class.send(:rollback_method_name)

            send(rollback_method_name) if rollback_method_name.present?
          end
        end
      end
    end
  end
end
