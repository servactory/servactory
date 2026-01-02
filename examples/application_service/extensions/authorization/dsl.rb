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

          def call!(**)
            super

            authorization_method_name = self.class.send(:authorization_method_name)

            return if authorization_method_name.nil?

            authorized = send(authorization_method_name)

            return if authorized

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
