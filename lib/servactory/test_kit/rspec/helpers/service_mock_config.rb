# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Configuration object for a single service mock.
        #
        # ## Purpose
        #
        # Holds all configuration for mocking a single service call, including
        # result type (success/failure), method type (call/call!), outputs,
        # exceptions, and argument matchers. Used by ServiceMockBuilder and
        # MockExecutor.
        #
        # ## Usage
        #
        # Usually created internally by ServiceMockBuilder:
        #
        # ```ruby
        # config = ServiceMockConfig.new(service_class: MyService)
        # config.result_type = :success
        # config.outputs = { user: user }
        # config.method_type = :call
        # ```
        #
        # ## Attributes
        #
        # - `service_class` - The service class being mocked
        # - `result_type` - :success or :failure
        # - `method_type` - :call or :call!
        # - `outputs` - Hash of output values
        # - `exception` - Exception for failure mocks
        # - `argument_matcher` - RSpec argument matcher or Hash
        class ServiceMockConfig
          attr_accessor :service_class,
                        :result_type,
                        :method_type,
                        :outputs,
                        :exception,
                        :argument_matcher,
                        :wrap_block

          # Creates a new mock configuration.
          #
          # @param service_class [Class] The service class to mock
          # @return [ServiceMockConfig] New config instance
          def initialize(service_class:)
            @service_class = service_class
            @result_type = nil
            @method_type = :call
            @outputs = {}
            @exception = nil
            @argument_matcher = nil
            @wrap_block = nil
          end

          # Checks if this is a success mock.
          #
          # @return [Boolean] True if result_type is :success
          def success?
            result_type == :success
          end

          # Checks if this is a failure mock.
          #
          # @return [Boolean] True if result_type is :failure
          def failure?
            result_type == :failure
          end

          # Checks if this is a call_original mock.
          #
          # @return [Boolean] True if result_type is :call_original
          def call_original?
            result_type == :call_original
          end

          # Checks if this is a wrap_original mock.
          #
          # @return [Boolean] True if result_type is :wrap_original
          def wrap_original?
            result_type == :wrap_original
          end

          # Checks if this mocks the .call! method.
          #
          # @return [Boolean] True if method_type is :call!
          def bang_method?
            method_type == :call!
          end

          # Checks if result type has been set.
          #
          # @return [Boolean] True if result_type is not nil
          def result_type_defined?
            !result_type.nil?
          end

          # Builds a Servactory::TestKit::Result from this config.
          #
          # @return [Servactory::TestKit::Result] Mock result object
          def build_result
            result_attrs = outputs.merge(service_class:)

            if success?
              Servactory::TestKit::Result.as_success(**result_attrs)
            else
              result_attrs[:exception] = exception if exception
              Servactory::TestKit::Result.as_failure(**result_attrs)
            end
          end

          # Builds RSpec argument matcher from config.
          #
          # If no matcher specified, builds one from service input names.
          #
          # @param rspec_context [Object] The RSpec test context
          # @return [Object] RSpec argument matcher
          def build_argument_matcher(rspec_context)
            return argument_matcher if argument_matcher.present?

            input_names = service_class.info.inputs.keys
            return rspec_context.no_args if input_names.empty?

            input_names.to_h { |input_name| [input_name, rspec_context.anything] }
          end

          # Creates a deep copy of this config.
          #
          # @return [ServiceMockConfig] New config with copied values
          def dup # rubocop:disable Metrics/AbcSize
            copy = self.class.new(service_class:)
            copy.result_type = result_type
            copy.method_type = method_type
            copy.outputs = outputs.dup
            copy.exception = exception
            copy.argument_matcher = argument_matcher
            copy.wrap_block = wrap_block
            copy
          end
        end
      end
    end
  end
end
