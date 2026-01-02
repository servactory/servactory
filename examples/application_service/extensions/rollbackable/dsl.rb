# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Rollbackable
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
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

          def call!(**)
            super
          rescue StandardError => e
            _perform_rollback(exception: e)

            raise
          end

          def _perform_rollback(exception:) # rubocop:disable Lint/UnusedMethodArgument
            rollback_method_name = self.class.send(:rollback_method_name)

            return if rollback_method_name.blank?

            send(rollback_method_name)
          end
        end
      end
    end
  end
end
