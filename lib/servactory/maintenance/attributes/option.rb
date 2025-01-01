# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class Option
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
        ) # do
          @name = name.to_sym
          @validation_class = validation_class
          @define_methods = define_methods
          @define_conflicts = define_conflicts
          @need_for_checks = need_for_checks

          @body = prepare_value_for(
            original_value:,
            options:,
            body_key:,
            body_value:,
            body_fallback:,
            with_advanced_mode:
          )

          prepare_methods_for(attribute)
        end
        # rubocop:enable Metrics/MethodLength

        def need_for_checks?
          need_for_checks
        end

        private

        def prepare_value_for(
          original_value:,
          options:,
          body_key:,
          body_value:,
          body_fallback:,
          with_advanced_mode:
        )
          return original_value if original_value.present?

          return options.fetch(@name, body_fallback) unless with_advanced_mode

          prepare_advanced_for(
            body: options.fetch(@name, DEFAULT_BODY.call(key: body_key, body: body_fallback)),
            body_key:,
            body_value:,
            body_fallback:
          )
        end

        # rubocop:disable Metrics/MethodLength
        def prepare_advanced_for(
          body:,
          body_key:,
          body_value:,
          body_fallback:
        )
          if body.is_a?(Hash)
            if @name == :schema && body.fetch(body_key, nil).nil?
              DEFAULT_BODY.call(key: body_key, body:)
            else
              message = body.fetch(:message, nil)

              DEFAULT_BODY.call(
                key: body_key,
                body: body.fetch(body_key, message.present? ? body_value : body_fallback),
                message:
              )
            end
          else
            DEFAULT_BODY.call(key: body_key, body:)
          end
        end
        # rubocop:enable Metrics/MethodLength

        def prepare_methods_for(attribute)
          attribute.instance_eval(define_methods_template) if define_methods_template.present?
        end

        def define_methods_template
          return if @define_methods.blank?

          @define_methods_template ||= @define_methods.map do |define_method|
            <<-RUBY.squish
              def #{define_method.name};
                #{define_method.content.call(option: @body)};
              end
            RUBY
          end.join("; ")
        end
      end
    end
  end
end
