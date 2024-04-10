# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        RSpec::Matchers.define :be_failure_service do
          description { "service failure" }

          match do |actual|
            expected_failure_class =
              defined?(@expected_failure_class) ? @expected_failure_class : Servactory::Exceptions::Failure

            expected_type = defined?(@expected_type) ? @expected_type : :base
            expected_message = defined?(@expected_message) ? @expected_message : nil
            expected_meta = defined?(@expected_meta) ? @expected_meta : nil

            matched = actual.is_a?(Servactory::Result)
            matched &&= !actual.success?
            matched &&= actual.failure?
            matched &&= actual.error.is_a?(Servactory::Exceptions::Failure)
            matched &&= actual.error.instance_of?(expected_failure_class)
            matched &&= actual.error.type == expected_type
            matched &&= actual.error.message == expected_message
            matched &&= actual.error.meta == expected_meta
            matched
          end

          chain :as do |expected_failure_class|
            @expected_failure_class = expected_failure_class
          end

          chain :with_type do |expected_type|
            @expected_type = expected_type
          end

          chain :with_message do |expected_message|
            @expected_message = expected_message
          end

          chain :with_meta do |expected_meta|
            @expected_meta = expected_meta
          end

          failure_message do |actual|
            message = []

            if actual.error.is_a?(Servactory::Exceptions::Failure)
              if defined?(@expected_failure_class)
                unless actual.error.instance_of?(@expected_failure_class)
                  message << "Error is not an instance of `#{@expected_failure_class}`"
                end
              else
                unless actual.error.instance_of?(Servactory::Exceptions::Failure)
                  message << "Error is not an instance of `Servactory::Exceptions::Failure`"
                end
              end

              if defined?(@expected_type) && actual.error.type != @expected_type
                message << "Does not have the expected type `#{@expected_type.inspect}`"
              end

              if defined?(@expected_message) && actual.error.message != @expected_message
                message << "Does not contain the expected error message `#{@expected_message.inspect}`"
              end

              if defined?(@expected_meta) && actual.error.meta != @expected_meta
                message << "Does not contain the expected metadata `#{@expected_meta.inspect}`"
              end

              message
            else
              message << "Error is not a `Servactory::Exceptions::Failure` object"
            end

            "[#{described_class}] #{message.join('; ')}."
          end
        end

        RSpec::Matchers.define :be_success_service do
          description { "service success" }

          def expected_data
            @expected_data ||= {}
          end

          match do |actual|
            matched = actual.instance_of?(Servactory::Result)
            matched &&= actual.success?
            matched &&= !actual.failure?

            if defined?(expected_data)
              matched &&= expected_data.all? do |key, value|
                actual.send(key) == value
              end
            end

            matched
          end

          chain :with_output do |key, value|
            expected_data[key] = value
          end

          chain :with_outputs do |attributes|
            attributes.each do |key, value|
              expected_data[key] = value
            end
          end

          failure_message do |actual|
            message = []

            if actual.instance_of?(Servactory::Result)
              message << "Result of the service is not successful" unless actual.success?
              message << "Result of the service is a failure" if actual.failure?

              if defined?(expected_data)
                expected_data.each do |key, value|
                  next if actual.send(key) == value

                  message << "Does not contain the expected value of `#{value.inspect}` in `#{key.inspect}`"
                end
              end
            else
              message << "Result of the service is not an instance of `Servactory::Result`"
            end

            "[#{described_class}] #{message.join('; ')}."
          end
        end
      end
    end
  end
end
