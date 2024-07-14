# frozen_string_literal: true

require_relative "matchers/have_service_input_matcher"
require_relative "matchers/have_service_internal_matcher"

module Servactory
  module TestKit
    module Rspec
      module Matchers # rubocop:disable Metrics/ModuleLength
        def have_service_input(input_name) # rubocop:disable Naming/PredicateName
          HaveServiceInputMatcher.new(described_class, input_name)
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

          chain :note do |note|
            @note = note
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

            if defined?(@note) && @note.present?
              attribute_data = described_class.info.outputs.fetch(output_name)

              attribute_note = attribute_data.fetch(:note)

              expect(@note).to(RSpec::Matchers::BuiltIn::Eq.new(attribute_note))
            end

            self
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
            matched = actual.is_a?(Servactory::Result)
            matched &&= actual.success?
            matched &&= !actual.failure?

            if defined?(expected_data)
              matched &&= expected_data.all? do |key, value|
                if actual.respond_to?(key)
                  actual.public_send(key) == value
                else
                  false
                end
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

          failure_message do |actual| # rubocop:disable Metrics/BlockLength
            unless actual.instance_of?(Servactory::Result)
              break <<~MESSAGE
                Incorrect service result:

                  expected Servactory::Result
                       got #{actual.class.name}
              MESSAGE
            end

            if actual.failure?
              break <<~MESSAGE
                Incorrect service result:

                  expected success
                       got failure
              MESSAGE
            end

            if defined?(expected_data)
              message = expected_data.each do |key, value|
                unless actual.respond_to?(key)
                  break <<~MESSAGE
                    Non-existent value key in result:

                    expected #{actual.inspect}
                         got #{key}
                  MESSAGE
                end

                expected_value = actual.public_send(key)
                next if actual.public_send(key) == value

                break <<~MESSAGE
                  Incorrect result value for #{key}:

                    expected #{expected_value.inspect}
                         got #{value.inspect}
                MESSAGE
              end
            end

            break message if message.present?

            <<~MESSAGE
              Unexpected case when using `be_success_service`.

              Please try to build an example based on the documentation.
              Or report your problem to us:

                https://github.com/servactory/servactory/issues
            MESSAGE
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

          chain :with do |expected_failure_class|
            @expected_failure_class = expected_failure_class
          end

          chain :type do |expected_type|
            @expected_type = expected_type
          end

          chain :message do |expected_message|
            @expected_message = expected_message
          end

          chain :meta do |expected_meta|
            @expected_meta = expected_meta
          end

          failure_message do |actual| # rubocop:disable Metrics/BlockLength
            unless actual.instance_of?(Servactory::Result)
              break <<~MESSAGE
                Incorrect service result:

                  expected Servactory::Result
                       got #{actual.class.name}
              MESSAGE
            end

            if actual.success?
              break <<~MESSAGE
                Incorrect service result:

                  expected failure
                       got success
              MESSAGE
            end

            unless actual.error.is_a?(Servactory::Exceptions::Failure)
              break <<~MESSAGE
                Incorrect error object:

                  expected Servactory::Exceptions::Failure
                       got #{actual.error.class.name}
              MESSAGE
            end

            if defined?(@expected_failure_class)
              unless actual.error.instance_of?(@expected_failure_class)
                break <<~MESSAGE
                  Incorrect instance error:

                    expected #{@expected_failure_class}
                         got #{actual.error.class.name}
                MESSAGE
              end
            else
              unless actual.error.instance_of?(Servactory::Exceptions::Failure)
                break <<~MESSAGE
                  Incorrect error object:

                    expected Servactory::Exceptions::Failure
                         got #{actual.error.class.name}
                MESSAGE
              end
            end

            if defined?(@expected_type) && actual.error.type != @expected_type
              break <<~MESSAGE
                Incorrect error type:

                  expected #{actual.error.type.inspect}
                       got #{@expected_type.inspect}
              MESSAGE
            end

            if defined?(@expected_message) && actual.error.message != @expected_message
              break <<~MESSAGE
                Incorrect error message:

                  expected #{actual.error.message.inspect}
                       got #{@expected_message.inspect}
              MESSAGE
            end

            if defined?(@expected_meta) && actual.error.meta != @expected_meta
              break <<~MESSAGE
                Incorrect error meta:

                  expected #{actual.error.meta.inspect}
                       got #{@expected_meta.inspect}
              MESSAGE
            end

            <<~MESSAGE
              Unexpected case when using `be_failure_service`.

              Please try to build an example based on the documentation.
              Or report your problem to us:

                https://github.com/servactory/servactory/issues
            MESSAGE
          end
        end
      end
    end
  end
end
