# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        class ServiceMockConfig
          attr_accessor :service_class,
                        :result_type,
                        :method_type,
                        :outputs,
                        :exception,
                        :argument_matcher,
                        :validate_outputs

          def initialize(service_class:)
            @service_class = service_class
            @result_type = nil
            @method_type = :call
            @outputs = {}
            @exception = nil
            @argument_matcher = nil
            @validate_outputs = false
          end

          def success?
            result_type == :success
          end

          def failure?
            result_type == :failure
          end

          def bang_method?
            method_type == :call!
          end

          def validate_outputs?
            @validate_outputs
          end

          def result_type_defined?
            !result_type.nil?
          end

          def build_result
            result_attrs = outputs.merge(service_class:)

            if success?
              Servactory::TestKit::Result.as_success(**result_attrs)
            else
              result_attrs[:exception] = exception if exception
              Servactory::TestKit::Result.as_failure(**result_attrs)
            end
          end

          def build_argument_matcher(rspec_context)
            return argument_matcher if argument_matcher.present?

            input_names = service_class.info.inputs.keys
            return rspec_context.no_args if input_names.empty?

            input_names.to_h { |input_name| [input_name, rspec_context.anything] }
          end

          def dup # rubocop:disable Metrics/AbcSize
            copy = self.class.new(service_class:)
            copy.result_type = result_type
            copy.method_type = method_type
            copy.outputs = outputs.dup
            copy.exception = exception
            copy.argument_matcher = argument_matcher
            copy.validate_outputs = validate_outputs
            copy
          end
        end
      end
    end
  end
end
