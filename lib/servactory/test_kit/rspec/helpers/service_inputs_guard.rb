# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Verifies the inputs of calls received by a service mock.
        #
        # ## Purpose
        #
        # RSpec compares the number of arguments before applying an argument
        # matcher, so a stub constrained by ServiceInputsMatcher would reject
        # a call without arguments. Service mocks configured without `.with()`
        # therefore accept any arguments on the RSpec level, and the guard
        # verifies them inside the stub implementation before the mock responds.
        # Calls whose inputs the service would not accept raise the same error
        # as an RSpec argument mismatch.
        #
        # Verification is skipped while no inputs matcher is set, which is the
        # case for mocks constrained with `.with()`.
        #
        # ## Usage
        #
        # Used internally by MockExecutor:
        #
        # ```ruby
        # guard = ServiceInputsGuard.new(service_class: MyService, method_type: :call)
        # guard.inputs_matcher = ServiceInputsMatcher.new(MyService.info.inputs)
        #
        # guard.verify!([{ user_id: 1 }])
        # ```
        class ServiceInputsGuard
          # @return [ServiceInputsMatcher, nil] Matcher applied to received arguments, nil skips verification
          attr_accessor :inputs_matcher

          # Creates a guard without an inputs matcher.
          #
          # @param service_class [Class] The mocked service class
          # @param method_type [Symbol] The mocked method (:call or :call!)
          def initialize(service_class:, method_type:)
            @service_class = service_class
            @method_type = method_type
            @inputs_matcher = nil
          end

          # Verifies the arguments received by the mock.
          #
          # @param arguments [Array<Object>] The arguments the service was called with
          # @return [void]
          # @raise [RSpec::Mocks::MockExpectationError] If the arguments do not match the inputs matcher
          def verify!(arguments)
            return if @inputs_matcher.nil? || @inputs_matcher.args_match?(*arguments)

            raise RSpec::Mocks::MockExpectationError, unexpected_arguments_message(arguments)
          end

          private

          # Builds the message of RSpec's unexpected arguments error.
          #
          # @param arguments [Array<Object>] The arguments the service was called with
          # @return [String] Error message with expected and received arguments
          def unexpected_arguments_message(arguments)
            <<~MESSAGE.chomp
              #<#{@service_class.inspect} (class)> received #{@method_type.inspect} with unexpected arguments
                expected: (#{@inputs_matcher.description})
                     got: #{format_arguments(arguments)}
            MESSAGE
          end

          # Formats arguments the way RSpec does in failure messages.
          #
          # @param arguments [Array<Object>] The arguments the service was called with
          # @return [String] Formatted argument list
          def format_arguments(arguments)
            return "(no args)" if arguments.empty?

            "(#{arguments.map { |argument| RSpec::Support::ObjectFormatter.format(argument) }.join(', ')})"
          end
        end
      end
    end
  end
end
