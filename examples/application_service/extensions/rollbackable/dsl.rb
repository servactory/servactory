# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Rollbackable
      # Provides rollback functionality on service failure.
      #
      # ## Purpose
      #
      # Executes a rollback method when service raises an exception.
      # Uses isolated extension configuration to store rollback settings.
      #
      # ## Usage
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   on_rollback :cleanup
      #
      #   private
      #
      #   def cleanup
      #     # rollback logic
      #   end
      # end
      # ```
      #
      # ## Configuration Isolation
      #
      # This extension uses isolated config namespace to prevent collisions:
      #
      # ```ruby
      # extension_config(:actions, :rollbackable)[:method_name] = :cleanup
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

          def on_rollback(method_name)
            extension_config(:actions, :rollbackable)[:method_name] = method_name
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super
          rescue StandardError => e
            raise e if e.is_a?(Servactory::Exceptions::Success)

            method_name = self.class.extension_config(:actions, :rollbackable)[:method_name]

            send(method_name) if method_name.present?

            raise
          end
        end
      end
    end
  end
end
