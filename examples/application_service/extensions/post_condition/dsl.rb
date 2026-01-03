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
      # Uses isolated extension configuration to store condition settings.
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
      # ## Configuration Isolation
      #
      # This extension uses isolated config namespace to prevent collisions:
      #
      # ```ruby
      # extension_config(:actions, :post_condition)[:conditions] ||= []
      # extension_config(:actions, :post_condition)[:conditions] << {
      #   name: :payment_recorded,
      #   message: "Payment must be saved",
      #   block: -> (outputs) { outputs.payment.persisted? }
      # }
      # ```
      #
      # ## Shared Access (if needed)
      #
      # Extensions can coordinate by reading other configs:
      #
      # ```ruby
      # # transactional_config = extension_config(:actions, :transactional)
      # # if transactional_config[:enabled]
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
            extension_config(:actions, :post_condition)[:conditions] ||= []
            extension_config(:actions, :post_condition)[:conditions] << {
              name:,
              message:,
              block:
            }
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super

            conditions = self.class.extension_config(:actions, :post_condition)[:conditions] || []

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
