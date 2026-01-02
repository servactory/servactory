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
            raise e if e.is_a?(Servactory::Exceptions::Success)

            rollback_method_name = self.class.send(:rollback_method_name)

            send(rollback_method_name) if rollback_method_name.present?

            raise
          end
        end
      end
    end
  end
end
