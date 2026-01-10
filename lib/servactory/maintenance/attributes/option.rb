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
                    :body

        # rubocop:disable Metrics/MethodLength
        def initialize(
          name:,
          attribute:,
          validation_class:,
          need_for_checks:,
          body_fallback:,
          original_value: nil,
          body_key: nil,
          body_value: true,
          define_methods: nil,
          define_conflicts: nil,
          with_advanced_mode: true,
          **options
        )
          @name = name.to_sym
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
            with_advanced_mode:
          )

          apply_dynamic_methods_to(attribute:)
        end
        # rubocop:enable Metrics/MethodLength

        def need_for_checks?
          need_for_checks
        end

        private

        def construct_body(
          original_value:,
          options:,
          body_key:,
          body_value:,
          body_fallback:,
          with_advanced_mode:
        )
          return original_value if original_value.present?
          return options.fetch(@name, body_fallback) unless with_advanced_mode

          use_advanced_mode(
            options:,
            body_key:,
            body_value:,
            body_fallback:
          )
        end

        def use_advanced_mode(options:, body_key:, body_value:, body_fallback:)
          default_body = create_default_body(body_key:, body_fallback:)
          body = extract_body_from_options(options:, default_body:)

          construct_advanced_body(
            body:,
            body_key:,
            body_value:,
            body_fallback:
          )
        end

        def create_default_body(body_key:, body_fallback:)
          DEFAULT_BODY.call(key: body_key, body: body_fallback)
        end

        def extract_body_from_options(options:, default_body:)
          options.fetch(@name, default_body)
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
