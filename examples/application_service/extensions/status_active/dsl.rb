# frozen_string_literal: true

module ApplicationService
  module Extensions
    module StatusActive
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          attr_accessor :status_active_model_name

          def status_active!(model_name)
            self.status_active_model_name = model_name
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super

            status_active_model_name = self.class.send(:status_active_model_name)

            return if status_active_model_name.nil?

            is_active = inputs.send(status_active_model_name).active?

            return if is_active

            fail_input!(
              status_active_model_name,
              message: "#{status_active_model_name.to_s.camelize.singularize} is not active"
            )
          end
        end
      end
    end
  end
end
