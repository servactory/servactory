# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Authorization
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
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

          def call!(incoming_arguments: {}, **)
            authorization_method_name = self.class.send(:authorization_method_name)

            if authorization_method_name.present?
              authorized = send(authorization_method_name, incoming_arguments)

              unless authorized
                fail!(
                  :unauthorized,
                  message: "Not authorized to perform this action"
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
