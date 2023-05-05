# frozen_string_literal: true

module Servactory
  module InputArguments
    module Checks
      class Must < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, code:|
          "[#{service_class_name}] Input `#{input.name}` " \
            "must \"#{code.to_s.humanize(capitalize: false, keep_id_suffix: true)}\""
        end

        private_constant :DEFAULT_MESSAGE

        def self.check(context:, input:, value:, check_key:, check_options:)
          return unless should_be_checked_for?(input, check_key)

          new(context: context, input: input, value: value, check_options: check_options).check
        end

        def self.should_be_checked_for?(input, check_key)
          check_key == :must && input.must_present?
        end

        ##########################################################################

        def initialize(context:, input:, value:, check_options:)
          super()

          @context = context
          @input = input
          @value = value
          @check_options = check_options
        end

        def check
          @check_options.each do |code, options|
            message = call_or_fetch_message_from(code, options)

            next if message.blank?

            add_error(
              DEFAULT_MESSAGE,
              service_class_name: @context.class.name,
              input: @input,
              code: code
            )
          end

          errors
        end

        private

        def call_or_fetch_message_from(code, options) # rubocop:disable Metrics/MethodLength
          check, message = options.values_at(:is, :message)

          return if check.call(value: @value)

          message.presence || DEFAULT_MESSAGE
        rescue StandardError => _e
          message_text =
            "[#{@context.class.name}] Syntax error inside `#{code}` of `#{@input.name}` input"

          add_error(
            message_text,
            service_class_name: @context.class.name,
            input: @input,
            code: code
          )
        end
      end
    end
  end
end
