# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Authorization
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        def self.register_hooks(service_class)
          service_class.before_actions(:_perform_authorization, priority: -100)
        end

        module ClassMethods
          private

          attr_accessor :authorization_method_name

          def authorize_with(method_name)
            self.authorization_method_name = method_name
          end
        end

        module InstanceMethods
          private

          def _perform_authorization(**)
            authorization_method_name = self.class.send(:authorization_method_name)

            return if authorization_method_name.nil?

            authorized = send(authorization_method_name)

            unless authorized
              fail!(
                :unauthorized,
                message: "Not authorized to perform this action"
              )
            end
          end
        end
      end
    end
  end
end
