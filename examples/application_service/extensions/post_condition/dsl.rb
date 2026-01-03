# frozen_string_literal: true

module ApplicationService
  module Extensions
    module PostCondition
      # Validates conditions after service execution.
      #
      # ## Purpose
      #
      # Ensures that certain conditions are met after the service runs.
      # Useful for business rule validation on outputs.
      # Uses Stroma settings to store condition configuration.
      #
      # ## Usage
      #
      # ```ruby
      # class ProcessPaymentService < ApplicationService::Base
      #   post_condition! :payment_recorded, message: "Payment must be saved" do |outputs|
      #     outputs.payment.persisted?
      #   end
      #
      #   post_condition! :positive_amount do |outputs|
      #     outputs.payment.amount.positive?
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
      # stroma.settings[:actions][:post_condition][:conditions] ||= []
      # stroma.settings[:actions][:post_condition][:conditions] << {
      #   name: :payment_recorded,
      #   message: "Payment must be saved",
      #   block: -> (outputs) { outputs.payment.persisted? }
      # }
      #
      # # InstanceMethods:
      # self.class.stroma.settings[:actions][:post_condition][:conditions]
      # ```
      #
      # ## Cross-Extension Coordination
      #
      # Extensions can read other extensions' settings:
      #
      # ```ruby
      # # transactional_settings = stroma.settings[:actions][:transactional]
      # # if transactional_settings[:enabled]
      # #   # conditions run inside transaction
      # # end
      # ```
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          def post_condition!(name, message: nil, &block)
            stroma.settings[:actions][:post_condition][:conditions] ||= []
            stroma.settings[:actions][:post_condition][:conditions] << {
              name:,
              message:,
              block:
            }
          end
        end

        module InstanceMethods
          private

          def call!(**) # rubocop:disable Metrics/MethodLength
            super

            conditions = self.class.stroma.settings[:actions][:post_condition][:conditions] || []

            conditions.each do |condition|
              result = instance_exec(outputs, &condition[:block])

              next if result

              message = condition[:message] || "Post-condition '#{condition[:name]}' failed"

              fail!(
                :post_condition_failed,
                message:
              )
            end
          end
        end
      end
    end
  end
end
