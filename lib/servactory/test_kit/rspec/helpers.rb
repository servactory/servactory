# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        def allow_service_as_success!(service_class, with: nil, &block)
          allow_service!(service_class, :as_success, with:, &block)
        end

        def allow_service_as_success(service_class, with: nil, &block)
          allow_service(service_class, :as_success, with:, &block)
        end

        def allow_service_as_failure!(service_class, with: nil, &block)
          allow_service!(service_class, :as_failure, with:, &block)
        end

        def allow_service_as_failure(service_class, with: nil, &block)
          allow_service(service_class, :as_failure, with:, &block)
        end

        ########################################################################

        def allow_service!(service_class, result_type, with: nil, &block)
          allow_servactory(service_class, :call!, result_type, with:, &block)
        end

        def allow_service(service_class, result_type, with: nil, &block)
          allow_servactory(service_class, :call, result_type, with:, &block)
        end

        ########################################################################

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def allow_servactory(service_class, method_call, result_type, with: nil)
          method_call = method_call.to_sym
          result_type = result_type.to_sym

          unless %i[call! call].include?(method_call)
            raise ArgumentError, "Invalid value for `method_call`. Must be `:call!` or `:call`."
          end

          unless %i[as_success as_failure].include?(result_type)
            raise ArgumentError, "Invalid value for `result_type`. Must be `:as_success` or `:as_failure`."
          end

          as_success = result_type == :as_success
          with_bang = method_call == :call!

          if block_given? && !yield.is_a?(Hash) && as_success
            raise ArgumentError, "Invalid value for block. Must be a Hash with attributes."
          end

          and_return_or_raise = with_bang && !as_success ? :and_raise : :and_return

          result = if block_given?
                     if yield.is_a?(Hash)
                       yield
                     else
                       { (with_bang ? :exception : :error) => yield }
                     end
                   else
                     {}
                   end

          result[:service_class] = service_class

          allow(service_class).to(
            receive(method_call)
              .with(
                if with.present?
                  with
                elsif (input_names = service_class.info.inputs.keys).present?
                  input_names.to_h { |input_name| [input_name, anything] }
                else
                  no_args
                end
              )
              .public_send(
                and_return_or_raise,
                Servactory::TestKit::Result.public_send(result_type, **result)
              )
          )
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      end
    end
  end
end
