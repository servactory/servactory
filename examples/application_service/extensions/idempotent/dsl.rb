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

          def call!(incoming_arguments: {}, **)
            idempotency_key_input = self.class.send(:idempotency_key_input)
            @_idempotency_was_cached = false

            if idempotency_key_input.present?
              store = self.class.send(:idempotency_store_class) || default_idempotency_store
              key = incoming_arguments[idempotency_key_input]

              if key.present?
                cached_result = store.get(key)

                if cached_result.present?
                  @_idempotency_was_cached = true
                  @_idempotency_cached_outputs = cached_result
                end
              end
            end

            super

            _apply_or_store_idempotency_result
          end

          def _apply_or_store_idempotency_result
            idempotency_key_input = self.class.send(:idempotency_key_input)

            return if idempotency_key_input.nil?

            if @_idempotency_was_cached
              @_idempotency_cached_outputs.each do |output_name, output_value|
                outputs.send(:"#{output_name}=", output_value)
              end
            else
              store = self.class.send(:idempotency_store_class) || default_idempotency_store
              key = inputs.send(idempotency_key_input)

              store.set(key, outputs.except)
            end
          end

          def default_idempotency_store
            fail!(:idempotency_error, message: "Idempotency store not configured")
          end
        end
      end
    end
  end
end
