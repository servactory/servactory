# frozen_string_literal: true

module Servactory
  module Inputs
    class Option
      DEFAULT_BODY = ->(key:, body:, message: nil) { { key => body, message: message } }

      private_constant :DEFAULT_BODY

      attr_reader :name,
                  :validation_class,
                  :define_input_methods,
                  :define_input_conflicts,
                  :need_for_checks,
                  :body_key,
                  :body_value,
                  :body

      # rubocop:disable Metrics/MethodLength
      def initialize(
        name:,
        input:,
        validation_class:,
        need_for_checks:,
        body_fallback:,
        original_value: nil,
        body_key: nil,
        body_value: true,
        define_input_methods: nil,
        define_input_conflicts: nil,
        with_advanced_mode: true,
        **options
      ) # do
        @name = name.to_sym
        @validation_class = validation_class
        @define_input_methods = define_input_methods
        @define_input_conflicts = define_input_conflicts
        @need_for_checks = need_for_checks
        @body_key = body_key
        @body_value = body_value

        @body = prepare_value_for(
          original_value: original_value,
          options: options,
          body_fallback: body_fallback,
          with_advanced_mode: with_advanced_mode
        )

        prepare_input_methods_for(input)
      end
      # rubocop:enable Metrics/MethodLength

      def need_for_checks?
        need_for_checks
      end

      private

      def prepare_value_for(original_value:, options:, body_fallback:, with_advanced_mode:)
        return original_value if original_value.present?

        return options.fetch(@name, body_fallback) unless with_advanced_mode

        prepare_advanced_for(
          body: options.fetch(@name, DEFAULT_BODY.call(key: body_key, body: body_fallback)),
          body_fallback: body_fallback
        )
      end

      def prepare_advanced_for(body:, body_fallback:)
        if body.is_a?(Hash)
          message = body.fetch(:message, nil)

          DEFAULT_BODY.call(
            key: body_key,
            body: body.fetch(body_key, message.present? ? body_value : body_fallback),
            message: message
          )
        else
          DEFAULT_BODY.call(key: body_key, body: body)
        end
      end

      def prepare_input_methods_for(input)
        input.instance_eval(define_input_methods_template) if define_input_methods_template.present?
      end

      def define_input_methods_template
        return if @define_input_methods.blank?

        @define_input_methods_template ||= @define_input_methods.map do |define_input_method|
          <<-RUBY
            def #{define_input_method.name}
              #{define_input_method.content.call(option: @body)}
            end
          RUBY
        end.join("\n")
      end
    end
  end
end
