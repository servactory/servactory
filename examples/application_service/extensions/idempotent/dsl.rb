# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Idempotent
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          attr_accessor :idempotency_key_input,
                        :idempotency_store_class

          def idempotent!(by:, store: nil)
            self.idempotency_key_input = by
            self.idempotency_store_class = store
          end
        end

        module InstanceMethods
          private

          def call!(incoming_arguments: {}, **) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
            idempotency_key_input = self.class.send(:idempotency_key_input)
            idempotency_was_cached = false
            cached_outputs = nil

            if idempotency_key_input.present?
              store = self.class.send(:idempotency_store_class)

              fail!(:idempotency_error, message: "Idempotency store not configured") if store.nil?

              key = incoming_arguments[idempotency_key_input]

              if key.present?
                cached_result = store.get(key)

                if cached_result.present?
                  idempotency_was_cached = true
                  cached_outputs = cached_result
                end
              end
            end

            super

            return if idempotency_key_input.nil?

            if idempotency_was_cached
              cached_outputs.each do |output_name, output_value|
                outputs.send(:"#{output_name}=", output_value)
              end
            else
              store = self.class.send(:idempotency_store_class)
              key = inputs.send(idempotency_key_input)

              store.set(key, outputs.except)
            end
          end
        end
      end
    end
  end
end
