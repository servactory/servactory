# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Authorization
      # Provides authorization checks before service actions.
      #
      # ## Purpose
      #
      # Validates that the current user has permission to execute the service.
      # Uses Stroma settings to store authorization configuration.
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
      # ## Settings Access
      #
      # This extension uses the Stroma settings hierarchy:
      #
      # ```ruby
      # # ClassMethods:
      # stroma.settings[:actions][:authorization][:method_name] = :authorize
      #
      # # InstanceMethods:
      # self.class.stroma.settings[:actions][:authorization][:method_name]
      # ```
      #
      # ## Cross-Extension Coordination
      #
      # Extensions can read other extensions' settings:
      #
      # ```ruby
      # # transactional_settings = stroma.settings[:actions][:transactional]
      # # if transactional_settings[:enabled]
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
            stroma.settings[:actions][:authorization][:method_name] = method_name
          end
        end

        module InstanceMethods
          private

          def call!(incoming_arguments: {}, **) # rubocop:disable Metrics/MethodLength
            method_name = self.class.stroma.settings[:actions][:authorization][:method_name]

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
