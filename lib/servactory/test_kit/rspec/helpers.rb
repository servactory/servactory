# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        def allow_service_as_success!(service_class_name, &block)
          allow_service!(service_class_name, :as_success, &block)
        end

        def allow_service_as_success(service_class_name, &block)
          allow_service(service_class_name, :as_success, &block)
        end

        def allow_service_as_failure!(service_class_name, &block)
          allow_service!(service_class_name, :as_failure, &block)
        end

        def allow_service_as_failure(service_class_name, &block)
          allow_service(service_class_name, :as_failure, &block)
        end

        ########################################################################

        def allow_service!(service_class_name, result_type, &block)
          allow_servactory(service_class_name, :call!, result_type, &block)
        end

        def allow_service(service_class_name, result_type, &block)
          allow_servactory(service_class_name, :call, result_type, &block)
        end

        ########################################################################

        def allow_servactory(service_class_name, method_call, result_type) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          method_call = method_call.to_sym
          result_type = result_type.to_sym

          unless %i[call! call].include?(method_call)
            raise ArgumentError, "Invalid value for `method_call`. Must be `:call!` or `:call`."
          end

          unless %i[as_success as_failure].include?(result_type)
            raise ArgumentError, "Invalid value for `result_type`. Must be `:as_success` or `:as_failure`."
          end

          if !yield.is_a?(Hash) && result_type == :as_success
            raise ArgumentError, "Invalid value for block. Must be a Hash with attributes."
          end

          and_return_or_raise = method_call == :call! ? :and_raise : :and_return

          result = yield.is_a?(Hash) ? yield : { error: yield }

          allow(service_class_name).to(
            receive(method_call)
              .send(
                and_return_or_raise,
                Servactory::TestKit::Result.send(result_type, result)
              )
          )
        end
      end
    end
  end
end
