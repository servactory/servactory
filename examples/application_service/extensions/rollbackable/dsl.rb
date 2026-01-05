# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Rollbackable
      # Provides rollback functionality on service failure.
      #
      # ## Purpose
      #
      # Executes a rollback method when service raises an exception.
      # Uses Stroma settings to store rollback configuration.
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
      # ## Settings Access
      #
      # This extension uses the Stroma settings hierarchy:
      #
      # ```ruby
      # # ClassMethods:
      # stroma.settings[:actions][:rollbackable][:method_name] = :cleanup
      #
      # # InstanceMethods:
      # self.class.stroma.settings[:actions][:rollbackable][:method_name]
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

          def on_rollback(method_name)
            stroma.settings[:actions][:rollbackable][:method_name] = method_name
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super
          rescue StandardError => e
            raise e if e.is_a?(Servactory::Exceptions::Success)

            method_name = self.class.stroma.settings[:actions][:rollbackable][:method_name]

            send(method_name) if method_name.present?

            raise
          end
        end
      end
    end
  end
end
