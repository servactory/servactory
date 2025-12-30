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

          def call!(**)
            super

            idempotency_key_input = self.class.send(:idempotency_key_input)
            return if idempotency_key_input.nil?

            store = self.class.send(:idempotency_store_class) || default_idempotency_store
            key = inputs.send(idempotency_key_input)

            cached_result = store.get(key)

            if cached_result.present?
              cached_result.each do |output_name, output_value|
                outputs.send(:"#{output_name}=", output_value)
              end
            else
              store.set(key, outputs.except)
            end
          end

          def default_idempotency_store
            fail!(message: "Idempotency store not configured")
          end
        end
      end
    end
  end
end
