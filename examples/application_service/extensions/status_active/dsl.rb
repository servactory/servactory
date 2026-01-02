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

          def call!(incoming_arguments: {}, **)
            status_active_model_name = self.class.send(:status_active_model_name)

            if status_active_model_name.present?
              model = incoming_arguments[status_active_model_name]

              unless model&.active?
                fail_input!(
                  status_active_model_name,
                  message: "#{status_active_model_name.to_s.camelize.singularize} is not active"
                )
              end
            end

            super
          end
        end
      end
    end
  end
end
