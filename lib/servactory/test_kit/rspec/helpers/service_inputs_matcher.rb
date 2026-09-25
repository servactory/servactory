# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Argument list matcher for inputs accepted by a service.
        #
        # ## Purpose
        #
        # Default argument matcher for service mocks configured without `.with()`.
        # A call matches when every required input is present and no undeclared
        # inputs are passed. Optional inputs may be omitted, so a call without
        # arguments matches when the service has no required inputs. Input values
        # are not constrained.
        #
        # ## Usage
        #
        # Built internally by ServiceMockConfig when no argument matcher is set
        # and applied to every call by ServiceInputsGuard:
        #
        # ```ruby
        # allow_service(MyService).succeeds(result: "ok")
        #
        # MyService.call(user_id: 1)
        # MyService.call({ user_id: 1, locale: "en" })
        # ```
        #
        # Both keyword arguments and a positional Hash are matched.
        class ServiceInputsMatcher
          # Creates a matcher from service input definitions.
          #
          # @param inputs [Hash{Symbol => Hash}] Input definitions from `service_class.info.inputs`
          def initialize(inputs)
            @input_names = inputs.keys
            @required_input_names = inputs.filter_map do |input_name, input|
              input_name if input.fetch(:actor).required?
            end
          end

          # Checks whether the call arguments contain acceptable service inputs.
          #
          # @param arguments [Array<Object>] The arguments the service was called with
          # @return [Boolean] True if all required inputs are present and no unknown inputs are passed
          def args_match?(*arguments)
            return @required_input_names.empty? if arguments.empty?
            return false unless arguments.one? && arguments.first.is_a?(Hash)

            inputs = arguments.first

            @required_input_names.all? { |input_name| inputs.key?(input_name) } &&
              inputs.each_key.all? { |input_name| @input_names.include?(input_name) }
          end

          # Describes the matcher for RSpec failure messages.
          #
          # @return [String] Matcher description
          def description
            "service_inputs(required: #{@required_input_names.inspect}, " \
              "optional: #{(@input_names - @required_input_names).inspect})"
          end

          alias inspect description
        end
      end
    end
  end
end
