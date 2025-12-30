# frozen_string_literal: true

module ApplicationService
  module Extensions
    module StatusActive
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        def self.register_hooks(service_class)
          service_class.before_actions(:_check_status_active, priority: -90)
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

          def _check_status_active(**)
            status_active_model_name = self.class.send(:status_active_model_name)

            return if status_active_model_name.nil?

            is_active = inputs.send(status_active_model_name).active?

            unless is_active
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
end
