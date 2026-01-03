# frozen_string_literal: true

module ApplicationService
  module Extensions
    module StatusActive
      # Validates model active status before service execution.
      #
      # ## Purpose
      #
      # Ensures that a specified model is active before proceeding.
      # Uses Stroma settings to store model configuration.
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
      # ## Settings Access
      #
      # This extension uses the Stroma settings hierarchy:
      #
      # ```ruby
      # # ClassMethods:
      # stroma.settings[:actions][:status_active][:model_name] = :user
      #
      # # InstanceMethods:
      # self.class.stroma.settings[:actions][:status_active][:model_name]
      # ```
      #
      # ## Cross-Extension Coordination
      #
      # Extensions can read other extensions' settings:
      #
      # ```ruby
      # # auth_settings = stroma.settings[:actions][:authorization]
      # # if auth_settings[:method_name].present?
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
            stroma.settings[:actions][:status_active][:model_name] = model_name
          end
        end

        module InstanceMethods
          private

          def call!(incoming_arguments: {}, **) # rubocop:disable Metrics/MethodLength
            model_name = self.class.stroma.settings[:actions][:status_active][:model_name]

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
