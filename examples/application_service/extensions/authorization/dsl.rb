# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Authorization
      # Provides authorization checks before service actions.
      #
      # ## Purpose
      #
      # Validates that the current user has permission to execute the service.
      # Uses isolated extension configuration to store authorization settings.
      #
      # ## Usage
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   authorize_with :check_permission
      #
      #   private
      #
      #   def check_permission(args)
      #     args[:user_role] == "admin"
      #   end
      # end
      # ```
      #
      # ## Configuration Isolation
      #
      # This extension uses isolated config namespace to prevent collisions:
      #
      # ```ruby
      # extension_config(:actions, :authorization)[:method_name] = :authorize
      # ```
      #
      # ## Shared Access (if needed)
      #
      # Extensions can coordinate by reading other configs:
      #
      # ```ruby
      # # transactional_config = extension_config(:actions, :transactional)
      # # if transactional_config[:enabled]
      # #   # coordinate with transactional extension
      # # end
      # ```
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          def authorize_with(method_name)
            extension_config(:actions, :authorization)[:method_name] = method_name
          end
        end

        module InstanceMethods
          private

          def call!(incoming_arguments: {}, **) # rubocop:disable Metrics/MethodLength
            method_name = self.class.extension_config(:actions, :authorization)[:method_name]

            if method_name.present?
              authorized = send(method_name, incoming_arguments)

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
