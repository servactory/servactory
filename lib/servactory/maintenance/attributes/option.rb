# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class Option # rubocop:disable Metrics/ClassLength
        DEFAULT_BODY = ->(key:, body:, message: nil) { { key => body, message: } }

        private_constant :DEFAULT_BODY

        attr_reader :name,
                    :validation_class,
                    :define_methods,
                    :define_conflicts,
                    :need_for_checks,
                    :body,
                    :body_key,
                    :return_value_on_access

        # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        def initialize(
          name:,
          attribute:,
          validation_class:,
          need_for_checks:,
          body_fallback:,
          original_value: nil,
          body_key: :is,
          body_value: true,
          define_methods: nil,
          define_conflicts: nil,
          detect_advanced_mode: true,
          return_value_on_access: false,
          normalizer: nil,
          **options
        )
          @name = name.to_sym
          @body_key = body_key
          @return_value_on_access = return_value_on_access
          @normalizer = normalizer
          @validation_class = validation_class
          @define_methods = define_methods
          @define_conflicts = define_conflicts
          @need_for_checks = need_for_checks

          @body = construct_body(
            original_value:,
            options:,
            body_key:,
            body_value:,
            body_fallback:,
            detect_advanced_mode:
          )

          apply_dynamic_methods_to(attribute:)
        end
        # rubocop:enable Metrics/MethodLength, Metrics/ParameterLists

        def value
          return body unless body.is_a?(Hash)

          body.fetch(@body_key, body)
        end

        def body_for_access
          @return_value_on_access ? value : body
        end

        def need_for_checks?
          need_for_checks
        end

        private

        # rubocop:disable Metrics/MethodLength
        def construct_body(
          original_value:,
          options:,
          body_key:,
          body_value:,
          body_fallback:,
          detect_advanced_mode:
        )
          return wrap_and_normalize(original_value) if original_value.present?

          raw_value = options.fetch(@name, body_fallback)

          result = if detect_advanced_mode
                     use_advanced_mode(
                       raw_value:,
                       body_key:,
                       body_value:,
                       body_fallback:
                     )
                   else
                     wrap_value(raw_value)
                   end

          apply_normalizer(result)
        end
        # rubocop:enable Metrics/MethodLength

        def wrap_and_normalize(value)
          result = wrap_value(value)
          apply_normalizer(result)
        end

        def apply_normalizer(body)
          return body unless @normalizer && body.is_a?(Hash)

          body[@body_key] = @normalizer.call(body[@body_key])
          body
        end

        def wrap_value(value)
          DEFAULT_BODY.call(key: @body_key, body: value)
        end

        def use_advanced_mode(raw_value:, body_key:, body_value:, body_fallback:)
          construct_advanced_body(
            body: raw_value,
            body_key:,
            body_value:,
            body_fallback:
          )
        end

        def construct_advanced_body(body:, body_key:, body_value:, body_fallback:)
          if body.is_a?(Hash)
            build_hash_body(body:, body_key:, body_value:, body_fallback:)
          else
            build_simple_body(body_key:, body:)
          end
        end

        def build_hash_body(body:, body_key:, body_value:, body_fallback:)
          message = body[:message]
          body_content = extract_body_content(
            body:,
            body_key:,
            body_value:,
            body_fallback:,
            message:
          )
          DEFAULT_BODY.call(key: body_key, body: body_content, message:)
        end

        def extract_body_content(body:, body_key:, body_value:, body_fallback:, message:)
          if message.present?
            body.fetch(body_key, body_value)
          else
            body.fetch(body_key, body_fallback)
          end
        end

        def build_simple_body(body_key:, body:)
          DEFAULT_BODY.call(key: body_key, body:)
        end

        def apply_dynamic_methods_to(attribute:)
          return if @define_methods.blank?

          attribute.instance_eval(generate_methods_code)
        end

        def generate_methods_code
          return if @define_methods.blank?

          @define_methods.map do |define_method|
            "def #{define_method.name}; #{define_method.content.call(option: @body)}; end"
          end.join("; ")
        end
      end
    end
  end
end
