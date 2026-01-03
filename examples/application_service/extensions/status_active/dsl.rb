# frozen_string_literal: true

module ApplicationService
  module Extensions
    module StatusActive
      # Validates model active status before service execution.
      #
      # ## Purpose
      #
      # Ensures that a specified model is active before proceeding.
      # Uses isolated extension configuration to store model settings.
      #
      # ## Usage
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   status_active! :user
      #
      #   input :user, type: User
      # end
      # ```
      #
      # ## Configuration Isolation
      #
      # This extension uses isolated config namespace to prevent collisions:
      #
      # ```ruby
      # extension_config(:actions, :status_active)[:model_name] = :user
      # ```
      #
      # ## Shared Access (if needed)
      #
      # Extensions can coordinate by reading other configs:
      #
      # ```ruby
      # # auth_config = extension_config(:actions, :authorization)
      # # if auth_config[:method_name].present?
      # #   # coordinate with authorization extension
      # # end
      # ```
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          def status_active!(model_name)
            extension_config(:actions, :status_active)[:model_name] = model_name
          end
        end

        module InstanceMethods
          private

          def call!(incoming_arguments: {}, **) # rubocop:disable Metrics/MethodLength
            model_name = self.class.extension_config(:actions, :status_active)[:model_name]

            if model_name.present?
              model = incoming_arguments[model_name]

              unless model&.active?
                fail_input!(
                  model_name,
                  message: "#{model_name.to_s.camelize.singularize} is not active"
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
