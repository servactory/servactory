# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers # rubocop:disable Metrics/ModuleLength
        def have_service_input(input_name) # rubocop:disable Naming/PredicateName
          HaveServiceInputMatcher.new(self, described_class, input_name)
        end

        RSpec::Matchers.alias_matcher :have_input, :have_service_input

        def have_service_internal(internal_name) # rubocop:disable Naming/PredicateName
          HaveServiceInternalMatcher.new(described_class, internal_name)
        end

        RSpec::Matchers.alias_matcher :have_internal, :have_service_internal

        ########################################################################
        ########################################################################
        ########################################################################

        RSpec::Matchers.define :have_service_output do |output_name| # rubocop:disable Metrics/BlockLength
          description { "service output" }

          match do |actual|
            match_for(actual, output_name)
          end

          chain :instance_of do |class_or_name|
            @instance_of = Servactory::Utils.constantize_class(class_or_name)
          end

          chain :nested do |*values|
            @nested = values
          end

          chain :with do |value|
            @value = value
          end

          chain :match do |value|
            @match = value
          end

          failure_message do |actual|
            match_for(actual, output_name)
          end

          # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          def match_for(actual, output_name)
            given_value = actual.public_send(output_name)

            if defined?(@nested) && @nested.present?
              @nested.each do |method_name|
                next unless given_value.respond_to?(method_name)

                given_value = given_value.public_send(method_name)
              end
            end

            expect(given_value).to(
              if defined?(@instance_of)
                RSpec::Matchers::BuiltIn::BeAnInstanceOf.new(@instance_of)
              elsif @value.is_a?(Array)
                RSpec::Matchers::BuiltIn::ContainExactly.new(@value)
              elsif @value.is_a?(Hash)
                RSpec::Matchers::BuiltIn::Match.new(@value)
              elsif @value.is_a?(TrueClass) || @value.is_a?(FalseClass)
                RSpec::Matchers::BuiltIn::Equal.new(@value)
              elsif @value.is_a?(NilClass)
                RSpec::Matchers::BuiltIn::BeNil.new(@value)
              else
                RSpec::Matchers::BuiltIn::Eq.new(@value)
              end
            )
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        RSpec::Matchers.alias_matcher :have_output, :have_service_output

        RSpec::Matchers.define :be_success_service do # rubocop:disable Metrics/BlockLength
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
              message << "result of the service is not successful" unless actual.success?
              message << "result of the service is a failure" if actual.failure?

              if defined?(expected_data)
                expected_data.each do |key, value|
                  next if actual.send(key) == value

                  message << "does not contain the expected value of `#{value.inspect}` in `#{key.inspect}`"
                end
              end
            else
              message << "result of the service is not an instance of `Servactory::Result`"
            end

            "[#{described_class}] #{message.join(', ').upcase_first}."
          end
        end

        RSpec::Matchers.define :be_failure_service do # rubocop:disable Metrics/BlockLength
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

          failure_message do |actual| # rubocop:disable Metrics/BlockLength
            message = []

            if actual.instance_of?(Servactory::Result)
              message << "result of the service is not successful" unless actual.success?
              message << "result of the service is a failure" if actual.failure?

              if actual.error.is_a?(Servactory::Exceptions::Failure)
                # rubocop:disable Metrics/BlockNesting
                if defined?(@expected_failure_class)
                  unless actual.error.instance_of?(@expected_failure_class)
                    message << "error is not an instance of `#{@expected_failure_class}`"
                  end
                else
                  unless actual.error.instance_of?(Servactory::Exceptions::Failure)
                    message << "error is not an instance of `Servactory::Exceptions::Failure`"
                  end
                end
                # rubocop:enable Metrics/BlockNesting

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
                message << "error is not a `Servactory::Exceptions::Failure` object"
              end
            else
              message << "result of the service is not an instance of `Servactory::Result`"
            end

            "[#{described_class}] #{message.join(', ').upcase_first}."
          end
        end

        # RSpec::Matchers.define :raise_service_input do
        #   def supports_block_expectations?
        #     true
        #   end
        #
        #   match do |block|
        #     block.call
        #   rescue ApplicationService::Exceptions::Input
        #     true
        #   rescue StandardError => e
        #     @exception = e
        #     false
        #   end
        #
        #   failure_message do |_actual|
        #     <<-MESSAGE.squish
        #       expected ApplicationService::Exceptions::Input,
        #       got #{@exception.inspect}
        #     MESSAGE
        #   end
        # end

        # def raise_service_input
        #   def matches?(subject)
        #     subject.call
        #   rescue ApplicationService::Exceptions::Input
        #     true
        #   rescue StandardError
        #     false
        #   end
        # end

        # def raise_service_input(message = nil, &block)
        #   RSpec::Matchers::BuiltIn::RaiseError.new(ApplicationService::Exceptions::Input, message, &block)
        # end
        #
        # RSpec::Matchers.define_negated_matcher :not_raise_service_input, :raise_service_input
      end
    end
  end
end
