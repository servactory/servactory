# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        class ServiceExpectationBuilder
          include Concerns::ServiceClassValidation
          include Concerns::ErrorMessages

          def initialize(service_class, rspec_context:)
            validate_service_class!(service_class)

            @service_class = service_class
            @rspec_context = rspec_context
            @method_type = :call
            @result_type = :success
            @outputs = {}
            @exception = nil
            @call_count = nil
            @argument_matcher = nil
            @allow_setup = false
          end

          # Result type methods
          def as_success
            @result_type = :success
            self
          end

          def as_failure
            @result_type = :failure
            self
          end

          # Output configuration
          def with_outputs(outputs_hash)
            @outputs = @outputs.merge(outputs_hash)
            self
          end

          def with_output(name, value)
            with_outputs(name => value)
          end

          # Exception configuration (for failures)
          def with_exception(exception)
            @exception = exception
            self
          end

          # Method type selection
          def using_call!
            @method_type = :call!
            self
          end

          def using_call
            @method_type = :call
            self
          end

          # Start verification chain
          def to_have_been_called
            setup_allow_for_spy
            self
          end

          # Call count constraints
          def once
            @call_count = 1
            finalize_expectation
            self
          end

          def twice
            @call_count = 2
            finalize_expectation
            self
          end

          def times(count)
            @call_count = count
            finalize_expectation
            self
          end

          def at_least(count)
            @call_count = [:at_least, count]
            finalize_expectation
            self
          end

          def at_most(count)
            @call_count = [:at_most, count]
            finalize_expectation
            self
          end

          # Argument matching for verification
          def with(args_hash_or_matcher)
            @argument_matcher = args_hash_or_matcher
            finalize_expectation if @call_count
            self
          end

          private

          def setup_allow_for_spy
            return if @allow_setup

            @allow_setup = true
            result = build_result

            @rspec_context.allow(@service_class).to(
              @rspec_context.receive(@method_type).and_return(result)
            )
          end

          def finalize_expectation
            expectation = @rspec_context.expect(@service_class).to(
              @rspec_context.have_received(@method_type)
            )

            expectation = apply_argument_matcher(expectation)
            apply_call_count(expectation)
          end

          def apply_argument_matcher(expectation)
            return expectation unless @argument_matcher

            expectation.with(@argument_matcher)
          end

          def apply_call_count(expectation)
            case @call_count
            when 1
              expectation.once
            when 2
              expectation.twice
            when Integer
              expectation.exactly(@call_count).times
            when Array
              apply_range_call_count(expectation, @call_count)
            end
          end

          def apply_range_call_count(expectation, count_spec)
            type, count = count_spec

            case type
            when :at_least
              expectation.at_least(count).times
            when :at_most
              expectation.at_most(count).times
            end
          end

          def build_result
            result_attrs = @outputs.merge(service_class: @service_class)

            case @result_type
            when :success
              Servactory::TestKit::Result.as_success(**result_attrs)
            when :failure
              result_attrs[:exception] = @exception if @exception
              Servactory::TestKit::Result.as_failure(**result_attrs)
            end
          end
        end
      end
    end
  end
end
