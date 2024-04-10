# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        RSpec::Matchers.define :service_failure do
          description { "service failed" }

          match do |actual|
            expected_failure_class =
              defined?(@expected_failure_class) ? @expected_failure_class : Servactory::Exceptions::Failure

            expected_type = defined?(@expected_type) ? @expected_type : :base
            expected_message = defined?(@expected_message) ? @expected_message : nil
            expected_meta = defined?(@expected_meta) ? @expected_meta : nil

            matched = actual.is_a?(Servactory::Result)
            matched &&= actual.error.is_a?(Servactory::Exceptions::Failure)
            matched &&= actual.error.instance_of?(expected_failure_class)
            matched &&= actual.error.type == expected_type
            matched &&= actual.error.message == expected_message
            matched &&= actual.error.meta == expected_meta
            matched
          end

          chain :as do |expected_failure_class|
            @expected_failure_class = expected_failure_class # Servactory::Exceptions::Failure
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
                message << "does not have the expected type `#{@expected_type.inspect}`"
              end

              if defined?(@expected_message) && actual.error.message != @expected_message
                message << "does not contain the expected error message `#{@expected_message.inspect}`"
              end

              if defined?(@expected_meta) && actual.error.meta != @expected_meta
                message << "does not contain the expected metadata `#{@expected_meta.inspect}`"
              end

              message
            else
              message << "Error is not a `Servactory::Exceptions::Failure` object"
            end

            message.join(", ")
          end
        end
      end
    end
  end
end
